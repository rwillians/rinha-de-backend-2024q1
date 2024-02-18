defmodule RinhaWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by tests that require setting up
  a connection.

  Such tests rely on `Phoenix.ConnTest` and also import other functionality to
  make it easier to build common data structures and query the data layer.

  Finally, if the test case interacts with the database, we enable the SQL
  sandbox, so changes done to the database are reverted at the end of every
  test. If you are using PostgreSQL, you can even run database tests
  asynchronously by setting `use RinhaWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      @endpoint RinhaWeb.Endpoint

      use Plug.Test

      import Rinha.ClienteCase
      import Rinha.DataCase
      import RinhaWeb.ConnCase
    end
  end

  setup tags do
    Rinha.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Dispatches the request to the plug application.
  """
  defmacro req(method, path) do
    quote do
      conn(unquote(method), unquote(path))
      |> @endpoint.call([])
    end
  end

  defmacro req(method, path, params_or_body) do
    quote do
      conn(unquote(method), unquote(path), unquote(params_or_body))
      |> @endpoint.call([])
    end
  end
end
