#
#   COMPILE TIME CONFIGURATIONS
#   ===========================
#   Base configurations applied to all environments.
#

import Config

#
#   ECTO
#

config :rinha,
  ecto_repos: [Rinha.Repo],
  generators: [timestamp_type: :utc_datetime_usec]

#
#   ENDPOINT
#

config :rinha, RinhaWeb.Endpoint,
  scheme: :http,
  http_1_options: [enabled: true, compress: false],
  http_2_options: [enabled: true, compress: false],
  startup_log: :notice,
  server: true

config :rinha, :dev_routes?, false

#
#   LOGGER
#

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

#
#   OVERRIDES PER ENVIRONMENT
#

case config_env() do
  :test -> import_config("test.exs")
  :dev  -> import_config("dev.exs")
  _     -> import_config("remote.exs")
end
