defmodule Rinha.Repo.Migrations.CreateTransacoesTable do
  use Ecto.Migration

  def change do
    create table(:transacoes, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :cliente_id, :integer, null: false
      add :tipo, :string, size: 1, null: false
      add :valor, :integer, null: false
      add :descricao, :string, size: 10, null: false
    end

    create index(:transacoes, [:cliente_id, "id DESC"])
  end
end
