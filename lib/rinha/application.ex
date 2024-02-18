defmodule Rinha.Application do
  use Application

  @impl Application
  def start(_start_type, _start_arg) do
    children =
      List.flatten([
        Rinha.Repo,
        endpoint_child_specs(RinhaWeb.Endpoint)
      ])

    Supervisor.start_link(children, strategy: :one_for_one, name: Rinha.Supervisor)
  end

  #
  #   PRIVATE
  #

  def endpoint_child_specs(endpoint, opts \\ []) do
    {run_server?, opts} =
      Application.fetch_env!(:rinha, endpoint)
      |> Keyword.merge(opts)
      |> Keyword.pop(:enabled?, false)

    case run_server? do
      true -> [{Bandit, opts}]
      false -> []
    end
  end
end
