defmodule Rinha.Cliente do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias __MODULE__

  @repo Rinha.Repo

  @typedoc false
  @type t :: %Rinha.Cliente{
          id: integer,
          limite: pos_integer,
          saldo: integer,
          # ↓ virtual fields
          transacoes: [Rinha.Transacao.t()] | nil
        }

  @primary_key {:id, :integer, []}
  schema "clientes" do
    field :limite, :integer
    field :saldo, :integer
    has_many :transacoes, Rinha.Transacao
  end

  @doc """
  Cria uma estrutura de registro de alterações (`Ecto.Changeset`).
  """
  @spec changeset(record, params) :: Ecto.Changeset.t()
        when record: t,
             params: map

  def changeset(record \\ %Cliente{}, %{} = params) do
    record
    |> cast(params, [:limite, :saldo])
    |> validate_required([:limite, :saldo])
  end

  @doc """
  Paga um cliente por id.
  """
  @spec pegar_cliente(id, com: {:ultimas_transacoes, limite: pos_integer}) ::
          {:ok, cliente}
          | {:error, {:nao_encontrado, Rinha.Cliente, id: term}}
        when id: pos_integer,
             cliente: t

  def pegar_cliente(id, com: {:ultimas_transacoes, limite: n})
      when is_integer(id) do
    query =
      from c in Cliente,
        left_join: t in assoc(c, :transacoes),
        where: c.id == ^id,
        limit: ^n,
        preload: [transacoes: t],
        order_by: [desc: t.realizada_em]

    case @repo.one(query) do
      nil -> {:error, {:nao_encontrado, Cliente, id: id}}
      %Cliente{} = cliente -> {:ok, cliente}
    end
  end
end
