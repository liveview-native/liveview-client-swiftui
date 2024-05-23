import Config

config :logger, :level, :debug
config :logger, :backends, []

config :live_view_native, plugins: [
  LiveViewNative.SwiftUI
]

import_config "#{config_env()}.exs"
