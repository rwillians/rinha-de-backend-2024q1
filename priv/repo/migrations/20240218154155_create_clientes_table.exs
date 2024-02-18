defmodule Rinha.Repo.Migrations.CreateClientesTable do
  use Ecto.Migration

  def change do
    create table(:clientes) do
      add :limite, :integer, null: false
      add :saldo, :integer, null: false
    end
  end
end
