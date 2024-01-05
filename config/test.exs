import Config

config :live_view_native_stylesheet, :parsers, swiftui: LiveViewNative.SwiftUI.RulesParser

config :live_view_native_stylesheet,
  annotations: false

config :live_view_native, plugins: [
  LiveViewNative.SwiftUI
]

config 