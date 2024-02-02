defmodule RinhaWeb do
  use Supervisor

  @doc """
  Load common dependencies and configurations into the calling module.

      use RinhaWeb, type: :route

  """
  defmacro __using__(type: which)
           when which in [:route],
           do: apply(__MODULE__, which, [])

  @doc false
  def start_link(opts \\ []),
    do: Supervisor.start_link(__MODULE__, opts, name: RinhaWeb.Supervisor)

  @impl Supervisor
  def init(opts) do
    children =
      List.flatten([
        maybe_bandit(opts)
      ])

    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc false
  def route do
    quote do
      @behaviour Plug

      import Plug.Conn
      import Ex.Plug.Conn

      @doc false
      def init(opts), do: opts
    end
  end

  #
  #   PRIVATE
  #

  defp maybe_bandit(opts) do
    {run_server?, config} =
      Application.fetch_env!(:rinha, RinhaWeb.Endpoint)
      |> Keyword.merge(opts)
      |> Keyword.put(:plug, RinhaWeb.Endpoint)
      |> Keyword.pop(:server, false)

    case run_server? do
      true -> [{Bandit, config}]
      false -> []
    end
  end
end
