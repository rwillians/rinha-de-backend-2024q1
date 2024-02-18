defmodule Ex.Ecto.Changeset do
  @moduledoc """
  Extended functionalities to `Ecto.Changeset`.
  """

  import Ecto.Changeset
  import Regex, only: [replace: 3]
  import Keyword, only: [get: 3]
  import String, only: [to_existing_atom: 1]

  alias Ecto.Changeset

  @doc """
  Extracts error messages from an invalid changeset and returns them as a map
  where keys are the field names and values is a set of validation errors.
  """
  @spec to_errors_by_field(changeset) :: %{field_name => [error_message, ...]}
        when changeset: Ecto.Changeset.t(),
             field_name: atom,
             error_message: String.t()

  def to_errors_by_field(%Changeset{valid?: true}), do: %{}

  def to_errors_by_field(%Changeset{valid?: false} = changeset) do
    traverse_errors(changeset, fn {message, opts} ->
      replace(~r"%{(\w+)}", message, fn _, key ->
        opts
        |> get(to_existing_atom(key), key)
        |> to_string()
      end)
    end)
  end
end
