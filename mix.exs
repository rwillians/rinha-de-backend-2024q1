defmodule Rinha.MixProject do
  use Mix.Project

  def project do
    [
      app: :rinha,
      version: "0.1.0",
      elixir: "~> 1.16",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def aliases do
    [
      #
    ]
  end

  def application do
    [
      mod: {Rinha, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:bandit, "~> 1.2"},
      {:ecto_sql, "~> 3.11"},
      {:jason, "~> 1.4"},
      {:plug, "~> 1.15"},
      {:postgrex, ">= 0.0.0"},
      {:telemetry_metrics, "~> 0.6"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
