defmodule RinhaWeb do
  @moduledoc false

  @doc """
  Returns a set of child specs for running an endpoint (plug application).
  If the endpoint's `enabled?` configuration is set to `false`, then an empty
  list of child specs is returned.
  """
  @spec child_specs(endpoint, opts) :: [{module, configs}]
        when endpoint: module,
             opts: keyword,
             configs: keyword

  def child_specs(endpoint, opts \\ []) do
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
