defmodule Ex.Ecto.Changeset do
  @moduledoc """
  Extended functionality for `Ecto.Changeset`.
  """

  import String, only: [to_existing_atom: 1]

  @doc """
  Formats a changeset's error message. Meant to be used with
  `Ecto.Changeset.traverse_errors/2`.

      assert Ecto.Changeset.traverse_errors(changeset, &format_message/2) == %{
        password: ["is too short"]
      }

  See it in use at `test/support/data_case.ex`, on function
  `errors_on/2`.
  """
  def format_message(message, opts) do
    Regex.replace(~r"%{(\w+)}", message, fn _, key ->
      opts
      |> Keyword.get(to_existing_atom(key), key)
      |> to_string()
    end)
  end
end
