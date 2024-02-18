defmodule Rinha.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring access to the application's
  data layer.

  You may define functions here to be used as helpers in your tests.

  Finally, if the test case interacts with the database, we enable the SQL
  sandbox, so changes done to the database are reverted at the end of every
  test. If you are using PostgreSQL, you can even run database tests
  asynchronously by setting `use Rinha.DataCase, async: true`, although this
  option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Rinha.DataCase

      alias Rinha.Repo
    end
  end

  setup tags do
    Rinha.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def setup_sandbox(tags) do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Rinha.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  If the changeset has no errors, then an empty map is returned.

     assert map_size(errors_on(changeset)) == 0

  """
  @spec errors_on(changeset) :: %{field_name => [error_message, ...]}
        when changeset: Ecto.Changeset.t(),
             field_name: atom,
             error_message: String.t()

  def errors_on(changeset),
    do: Ex.Ecto.Changeset.to_errors_by_field(changeset)

  @doc """
  Same as `errors_on/1` but returns only the list of errors of a
  specific field.

      assert "password is too short" in errors_on(changeset, :password)

  If either the changeset has no errors or the field has no errors,
  then an empty list is returned.

     assert errors_on(changeset, :email) == []

  """
  @spec errors_on(changeset, field_name) :: [error_message]
        when changeset: Ecto.Changeset.t(),
             field_name: atom,
             error_message: String.t()

  def errors_on(changeset, field_name) do
    errors_on(changeset)
    |> Map.get(field_name, [])
  end
end
