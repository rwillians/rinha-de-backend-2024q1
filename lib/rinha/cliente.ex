defmodule Rinha.Cliente do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @typedoc false
  @type t :: %Rinha.Cliente{
          id: integer,
          limite: pos_integer,
          saldo: integer
        }

  @primary_key {:id, :integer, []}
  schema "clientes" do
    field :limite, :integer
    field :saldo, :integer

    has_many :transacoes, Rinha.Transacao
  end

  @doc false
  @spec changeset(record, params) :: Ecto.Changeset.t()
        when record: t,
             params: map

  def changeset(record \\ %Cliente{}, %{} = params) do
    record
    |> cast(params, [:id, :limite, :saldo])
    |> validate_required([:limite, :saldo])
  end
end
