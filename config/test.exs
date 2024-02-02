#
#   COMPILE TIME CONFIGURATIONS
#   ===========================
#   Configuration overrides for the test environment.
#

import Config

#
#   ECTO
#

config :rinha, Rinha.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

#
#   ENDPOINT
#

config :rinha, RinhaWeb.Endpoint,
  server: false
  #       ↑ we don't spin up the http server for tests, we call the
  #         plug application directly

#
#   LOGGER
#

config :logger, level: :warning
