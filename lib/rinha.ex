defmodule Rinha do
  @moduledoc false

  import Ecto.Query
  import Rinha.Cliente, only: [pegar_cliente: 2]

  alias Ecto.Changeset
  alias Rinha.Cliente
  alias Rinha.Transacao

  @repo Rinha.Repo

  @typedoc false
  @type extrato :: %{
          saldo: %{total: integer, data_extrato: DateTime.t(), limite: pos_integer},
          ultimas_transacoes: [Rinha.Transacao.t()]
        }

  @doc """
  Posta uma transação para um cliente.
  """
  @spec postar_transacao(campos) ::
          {:ok, extrato_resumido}
          | {:error, changeset_invalido}
          | {:error, {:nao_encontrado, Rinha.Cliente, id: term}}
          | {:error, :limite_excedido}
        when campos: map,
             extrato_resumido: %{saldo: integer, limite: pos_integer},
             changeset_invalido: Ecto.Changeset.t()

  def postar_transacao(campos) do
    with {:ok, transacao} <- Transacao.nova(campos),
         {:ok, %{cliente: {1, [cliente]}}} <- transacionar(transacao) do
      {:ok, Map.take(cliente, [:saldo, :limite])}
    else
      {:error, %Changeset{} = motivo} -> {:error, motivo}
      {:error, :abortar, motivo, _} -> {:error, motivo}
    end
  end

  defp transacionar(%Transacao{} = transacao) do
    cliente_id = transacao.cliente_id
    valor_delta = calcular_alteracao_de_saldo(transacao)
    query_cliente = query_incrementa_saldo_cliente(cliente_id, valor_delta)

    Ecto.Multi.new()
    |> Ecto.Multi.update_all(:cliente, query_cliente, [])
    |> Ecto.Multi.run(:abortar, fn
      _repo, %{cliente: {0, []}} -> {:error, {:nao_encontrado, Cliente, id: cliente_id}}
      _repo, %{cliente: {1, [%{saldo: s, limite: l}]}} when s < -l -> {:error, :limite_excedido}
      _repo, %{cliente: {1, [%{saldo: _, limite: _}]}} -> {:ok, nil}
    end)
    |> Ecto.Multi.insert(:transacao, transacao)
    |> @repo.transaction()
  end

  defp calcular_alteracao_de_saldo(%Transacao{tipo: :c, valor: valor}), do: valor
  defp calcular_alteracao_de_saldo(%Transacao{tipo: :d, valor: valor}), do: -valor

  defp query_incrementa_saldo_cliente(cliente_id, valor_delta) do
    from c in Cliente,
      where: c.id == ^cliente_id,
      update: [inc: [saldo: ^valor_delta]],
      select: [:saldo, :limite]
  end

  @doc """
  Pega o extrato de um cliente dado o seu id.
  """
  @spec pegar_extrato(cliente_id) ::
          {:ok, extrato}
          | {:error, {:nao_encontrado, Rinha.Cliente, id: term}}
        when cliente_id: pos_integer | String.t()

  def pegar_extrato(cliente_id) when is_integer(cliente_id) do
    with {:ok, %Cliente{} = cliente} <-
           pegar_cliente(cliente_id, com: {:ultimas_transacoes, limite: 10}) do
      balanco = %{
        total: cliente.saldo,
        limite: cliente.limite,
        data_extrato: DateTime.utc_now()
      }

      {:ok, %{saldo: balanco, ultimas_transacoes: cliente.transacoes}}
    end
  end

  def pegar_extrato(<<_, _::binary>> = cliente_id) do
    String.to_integer(cliente_id, 10)
  rescue
    # o cliente_id pode não ser um número base 10 válido
    _ -> {:error, {:nao_encontrado, Cliente, id: cliente_id}}
  else
    client_id -> pegar_extrato(client_id)
  end
end
