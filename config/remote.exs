#
#   COMPILE-TIME CONFIGURATIONS
#   ===========================
#   Configurations specific to the remote environments, which are all
#   environment that are non-local (dev and test). That's right,
#   production is a remote environment.
#

import Config

#
#   LOGGER
#

config :logger, level: :notice
config :logger, compile_time_purge_matching: [level_lower_than: :notice]
