#
#   RUNTIME CONFIGURATIONS
#   ======================
#   Loaded when booting the system, it set configurations to all
#   environments, including releases.
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
          System.get_env("DATABASE_URL") ||
          "postgres://postgres:postgres@localhost:5432/rinha_test"

  :dev ->
    config :rinha, Rinha.Repo,
      pool_size: String.to_integer(System.get_env("ECTO_POOL_SIZE") || "10"),
      url:
        System.get_env("DEV_DATABASE_URL") ||
          System.get_env("DATABASE_URL") ||
          "postgres://postgres:postgres@localhost:5432/rinha_dev"

  _remote ->
    database_url =
      System.get_env("DATABASE_URL") ||
        raise """
        environment variable DATABASE_URL is missing.
        For example: postgres://USER:PASS@HOST/DATABASE
        """

    ssl_enabled? = System.get_env("ECTO_SSL_ENABLED", "true") in ~w(true 1)
    pool_size = String.to_integer(System.get_env("ECTO_POOL_SIZE") || "15")

    config :rinha, Rinha.Repo,
      ssl: ssl_enabled?,
      url: database_url,
      pool_size: pool_size
end

#
#   ENDPOINT
#

case config_env() do
  :test ->
    :ok

  :dev ->
    config :rinha, RinhaWeb.Endpoint, port: String.to_integer(System.get_env("PORT") || "3000")

  _remote ->
    config :rinha, RinhaWeb.Endpoint,
      enabled?: System.get_env("SERVER_ENABLED", "true") in ~w(true 1),
      port: String.to_integer(System.get_env("PORT") || "3000")
end
