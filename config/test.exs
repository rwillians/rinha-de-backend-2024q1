#
#   COMPILE-TIME CONFIGURATIONS
#   ===========================
#   Configurations specific to the test environment.
#

import Config

#
#   ECTO
#

config :rinha, Rinha.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2,
  force_drop: true

#
#   ENDPOINT
#

config :rinha, RinhaWeb.Endpoint, enabled?: false
#   disable server because tests will send  ↑
#            requests directly to the plug
#                              application

#
#   LOGGER
#

config :logger, level: :warning

#
#   PLUG
#

config :plug, :validate_header_keys_during_test, true
