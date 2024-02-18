defmodule Rinha do
  @moduledoc false

  import Ecto.Changeset, only: [apply_action: 2]
  import Ecto.Query

  alias Ecto.Changeset
  alias Rinha.Cliente
  alias Rinha.Repo
  alias Rinha.Transacao

  @typedoc false
  @type extrato :: %{
          saldo: %{
            total: integer,
            data_extrato: DateTime.t(),
            limite: pos_integer
          },
          ultimas_transacoes: [
            %{
              tipo: :c | :d,
              valor: pos_integer,
              descricao: String.t(),
              realizada_em: DateTime.t()
            }
          ]
        }

  def postar_transacao(params) do
    changeset = Transacao.changeset(params)

    with {:ok, transacao} <- apply_action(changeset, :insert),
         {:ok, %{cliente: {1, [cliente]}}} <- transacionar(transacao) do
      {:ok, Map.take(cliente, [:saldo, :limite])}
    else
      {:error, %Changeset{}} = error -> error
      {:error, :abortar, error, _} -> {:error, error}
    end
  end

  defp calcular_valor_delta(%Transacao{tipo: :c, valor: valor}), do: valor
  defp calcular_valor_delta(%Transacao{tipo: :d, valor: valor}), do: -valor

  defp query_inc_saldo_cliente(cliente_id, valor_delta) do
    from c in Cliente,
      where: c.id == ^cliente_id,
      update: [inc: [saldo: ^valor_delta]],
      select: [:saldo, :limite]
  end

  defp transacionar(%Transacao{} = transacao) do
    cliente_id = transacao.cliente_id
    valor_delta = calcular_valor_delta(transacao)
    query_atualiza_saldo = query_inc_saldo_cliente(cliente_id, valor_delta)

    Ecto.Multi.new()
    |> Ecto.Multi.update_all(:cliente, query_atualiza_saldo, [])
    |> Ecto.Multi.run(:abortar, fn
      _repo, %{cliente: {0, []}} -> {:error, :cliente_nao_encontrado}
      _repo, %{cliente: {1, [%{saldo: s, limite: l}]}} when s < -l -> {:error, :limite_excedido}
      _repo, %{cliente: {1, [%{saldo: _, limite: _}]}} -> {:ok, nil}
    end)
    |> Ecto.Multi.insert(:transacao, transacao)
    |> Repo.transaction()
  end

  @doc """
  Pega o extrato de um cliente dado o seu id.
  """
  @spec pegar_extrato(cliente_id) ::
          {:ok, extrato}
          | {:error, :cliente_nao_encontrado}
        when cliente_id: pos_integer | String.t()

  def pegar_extrato(cliente_id) when is_integer(cliente_id) do
    query =
      from c in Cliente,
        left_join: t in assoc(c, :transacoes),
        where: c.id == ^cliente_id,
        limit: 10,
        preload: [transacoes: t],
        order_by: [desc: t.realizada_em]

    case Repo.one(query) do
      nil ->
        {:error, :cliente_nao_encontrado}

      cliente ->
        balance = %{
          total: cliente.saldo,
          limite: cliente.limite,
          data_extrato: DateTime.utc_now()
        }

        transacoes =
          Enum.map(cliente.transacoes, &Map.take(&1, [:tipo, :valor, :descricao, :realizada_em]))

        {:ok, %{saldo: balance, ultimas_transacoes: transacoes}}
    end
  end

  def pegar_extrato(<<_, _::binary>> = cliente_id) do
    String.to_integer(cliente_id)
  rescue
    # o cliente_id pode não ser um número válido
    _ -> {:error, :cliente_nao_encontrado}
  else
    client_id -> pegar_extrato(client_id)
  end
end
