#
#   COMPILE-TIME CONFIGURATIONS
#   ===========================
#   Configurations specific to the development environment.
#

import Config

#
#   ECTO
#

config :rinha, Rinha.Repo,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  force_drop: true

#
#   LOGGER
#

config :logger, level: :info
config :logger, :console, format: "[$level] $message\n"
