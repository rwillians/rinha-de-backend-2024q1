#
#   COMPILE TIME CONFIGURATIONS
#   ===========================
#   Configuration overrides for all environments other than `:dev` and
#   `:test`.
#

import Config

#
#   ECTO
#

config :rinha, Rinha.Repo,
  stacktrace: true,
  show_sensitive_data_on_connection_error: false

#
#   LOGGER
#

config :logger, level: :notice
config :logger, compile_time_purge_matching: [[level_lower_than: :notice]]
