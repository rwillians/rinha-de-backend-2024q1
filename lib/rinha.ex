defmodule Rinha do
  @moduledoc false

  alias Rinha.Cliente
  alias Rinha.Repo

  @typedoc false
  @type extrato :: %{
          saldo: %{
            total: integer,
            data_extrato: DateTime.t(),
            limite: pos_integer
          }
        }

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
