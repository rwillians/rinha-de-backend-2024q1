defmodule Rinha.ClienteCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Rinha.ClienteCase
    end
  end

  @doc """
  Cria um cliente com um dado limite (opcional).
  """
  def criar_cliente!([limite: limite] \\ [limite: 100_00]) do
    Rinha.Repo.insert!(%Rinha.Cliente{
      id: Enum.random(1..1_000_000),
      limite: limite,
      saldo: 0
    })
  end
end
