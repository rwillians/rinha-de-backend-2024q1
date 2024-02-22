defmodule Rinha.Transacao do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @typedoc false
  @type t :: %Rinha.Transacao{
          id: Ecto.UUID.t(),
          cliente_id: pos_integer,
          tipo: :c | :d,
          valor: non_neg_integer,
          descricao: String.t(),
          realizada_em: DateTime.t(),
          # ↓ virtual fields
          cliente: Rinha.Cliente.t() | nil
        }

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @derive {Jason.Encoder, only: [:tipo, :valor, :descricao, :realizada_em]}
  schema "transacoes" do
    belongs_to :cliente, Rinha.Cliente, type: :integer
    field :tipo, Ecto.Enum, values: [:c, :d]
    field :valor, :integer
    field :descricao, :string

    timestamps inserted_at: :realizada_em,
               updated_at: false,
               type: :utc_datetime_usec
  end

  @doc """
  Cria uma estrutura de registro de alterações (`Ecto.Changeset`).
  """
  @spec changeset(documento, alteracoes) :: Ecto.Changeset.t()
        when documento: t,
             alteracoes: map

  def changeset(documento \\ %Transacao{}, %{} = alteracoes) do
    documento
    |> cast(alteracoes, [:cliente_id, :tipo, :valor, :descricao])
    |> validate_required([:cliente_id, :tipo, :valor, :descricao])
    |> validate_inclusion(:tipo, [:c, :d])
    |> validate_length(:descricao, min: 1, max: 10)
  end

  @doc """
  Cria uma estrutura representando uma transação (não insere no banco de dados).
  """
  @spec nova(campos) :: {:ok, transacao} | {:error, changeset_invalido}
        when campos: map,
             transacao: t,
             changeset_invalido: Ecto.Changeset.t()

  def nova(%{} = campos) do
    campos
    |> changeset()
    |> apply_action(:new)
  end
end
