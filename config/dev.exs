#
#   COMPILE TIME CONFIGURATIONS
#   ===========================
#   Configuration overrides for the dev environment.
#

import Config

#
#   ECTO
#

config :rinha, Rinha.Repo,
  pool_size: 10,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

#
#   LOGGER
#

config :logger, level: :info
