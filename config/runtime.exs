#
#   RUNTIME CONFIGURATIONS
#   ======================
#   Runtime configurations are applied to any environment as the
#   application boots.
#

import Config

#
#   ECTO
#

case config_env() do
  :test ->
    config :rinha, Rinha.Repo,
      url:
        System.get_env("TEST_DATABASE_URL") ||
          "postgres://postgres:postgres@localhost:5432/rinha_test"

  :dev ->
    config :rinha, Rinha.Repo,
      url:
        System.get_env("DEV_DATABASE_URL") ||
          "postgres://postgres:postgres@localhost:5432/rinha_dev"

  _ ->
    use_ssl? = System.get_env("ECTO_SSL_ENABLED", "true") in ~w(true 1)

    maybe_ipv6 =
      if System.get_env("ECTO_IPV6") in ~w(true 1),
        do: [:inet6],
        else: []

    config :rinha, Rinha.Repo,
      url: System.fetch_env!("DATABASE_URL"),
      ssl: use_ssl?,
      pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
      socket_options: maybe_ipv6
end

#
#   ENDPOINT
#

if config_env() not in [:test] do
  config :rinha, RinhaWeb.Endpoint,
    port: String.to_integer(System.get_env("PORT") || "3000")
end
