defmodule Rinha.MixProject do
  use Mix.Project

  def project do
    [
      app: :rinha,
      version: "0.1.0",
      elixir: "~> 1.16",
      elixirc_paths: elixirc_paths(Mix.env()),
      elixirc_options: [debug_info: Mix.env() == :dev],
      build_embedded: Mix.env() not in [:dev, :test],
      start_permanent: Mix.env() not in [:dev, :test],
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Rinha.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  defp deps do
    [
      {:bandit, "~> 1.2"},
      {:ecto_sql, "~> 3.11"},
      {:jason, "~> 1.4"},
      {:plug, "~> 1.15"},
      {:postgrex, ">= 0.0.0"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
