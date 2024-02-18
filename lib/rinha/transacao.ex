defmodule Rinha.Transacao do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @typedoc false
  @type t :: %Rinha.Transacao{
          id: Ecto.UUID.t(),
          cliente_id: pos_integer,
          tipo: :c | :d,
          valor: integer,
          descricao: String.t()
        }

  @primary_key false
  schema "transacoes" do
    field :id, Ecto.ULID, autogenerate: true, primary_key: true
    field :cliente_id, :integer
    field :tipo, Ecto.Enum, values: [:c, :d]
    field :valor, :integer
    field :descricao, :string
  end

  @doc false
  @spec changeset(record, params) :: Ecto.Changeset.t()
        when record: t,
             params: map

  def changeset(record \\ %Transacao{}, %{} = params) do
    record
    |> cast(params, [:id, :cliente_id, :tipo, :valor, :descricao])
    |> validate_required([:cliente_id, :tipo, :valor, :descricao])
    |> validate_inclusion(:tipo, [:c, :d])
    |> validate_length(:descricao, min: 1, max: 10)
  end
end
