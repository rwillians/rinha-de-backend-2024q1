defmodule Rinha do
  @moduledoc false

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
          }
        }

  def postar_transacao(params) do
    changeset = Transacao.changeset(params)

    with {:ok, transacao} <- Changeset.apply_action(changeset, :insert),
         {:ok, %{cliente: {1, [cliente]}}} <- transacionar(transacao) do
      {:ok, Map.take(cliente, [:saldo, :limite])}
    else
      {:error, %Changeset{}} = error -> error
      {:error, :teste, error, _} -> {:error, error}
    end
  end

  defp calcular_valor_delta(%Transacao{tipo: :c, valor: valor}), do: valor
  defp calcular_valor_delta(%Transacao{tipo: :d, valor: valor}), do: -valor

  defp query_atualiza_saldo_cliente(cliente_id, valor_delta) do
    from c in Cliente,
      where: c.id == ^cliente_id,
      update: [inc: [saldo: ^valor_delta]],
      select: [:saldo, :limite]
  end

  defp transacionar(%Transacao{} = transacao) do
    cliente_id = transacao.cliente_id
    valor_delta = calcular_valor_delta(transacao)
    query_atualiza_saldo = query_atualiza_saldo_cliente(cliente_id, valor_delta)

    Ecto.Multi.new()
    |> Ecto.Multi.update_all(:cliente, query_atualiza_saldo, [])
    |> Ecto.Multi.insert(:transacao, transacao)
    |> Ecto.Multi.run(:teste, fn
      _repo, %{cliente: {0, []}} -> {:error, :cliente_nao_encontrado}
      _repo, %{cliente: {1, [%{saldo: s, limite: l}]}} when s < -l -> {:error, :limite_excedido}
      _repo, %{cliente: {1, [%{saldo: _, limite: _}]}} -> {:ok, nil}
    end)
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
    case Repo.get(Cliente, cliente_id) do
      nil ->
        {:error, :cliente_nao_encontrado}

      %Cliente{} = cliente ->
        saldo = %{
          total: cliente.saldo,
          data_extrato: DateTime.utc_now(),
          limite: cliente.limite
        }

        {:ok, %{saldo: saldo, ultimas_transacoes: []}}
    end
  end

  def pegar_extrato(<<_, _::binary>> = cliente_id) do
    cliente_id
    |> String.to_integer()
    |> pegar_extrato()
  rescue
    _ -> {:error, :cliente_nao_encontrado}
  end
end
