#
#   COMPILE-TIME CONFIGURATIONS
#   ===========================
#   Base compile-time configurations for all environments.
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
  enabled?: true,
  scheme: :http,
  plug: RinhaWeb.Endpoint,
  ip: {0, 0, 0, 0},
  otp_app: :rinha,
  startup_log: :notice,
  http_1_options: [enabled: true],
  http_2_options: [enabled: false]

#
#   LOGGER
#

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger,
  utc_log: true,
  sync_threshold: 100,
  truncate: :infinity

#
#   OVERRIDES
#   Overrides compile-time configurations per environment.
#

case config_env() do
  :test -> import_config("test.exs")
  :dev  -> import_config("dev.exs")
  _     -> import_config("remote.exs")
end
