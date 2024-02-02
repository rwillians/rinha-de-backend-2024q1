defmodule Rinha.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring access to the
  application's data layer.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import Ecto
      import Ecto.Changeset
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
      assert "password is too short" in errors_on(changeset, :password)
      assert ["password is too short"] = errors_on(changeset, :password)

  """
  def errors_on(changeset, field_name) do
    changeset
    |> Ecto.Changeset.traverse_errors(&Ex.Ecto.Changeset.format_message/2)
    |> Map.get(field_name, [])
  end
end
