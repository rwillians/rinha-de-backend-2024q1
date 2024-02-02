defmodule Rinha do
  use Application

  @impl Application
  def start(_start_type, _start_args) do
    children = [
      Rinha.Repo,
      RinhaWeb
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Rinha.Supervisor)
  end
end
