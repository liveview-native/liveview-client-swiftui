import Config

config :live_view_native_stylesheet, :parsers, swiftui: LiveViewNative.SwiftUI.RulesParser

config :live_view_native_stylesheet,
  annotations: false

config :phoenix_template, format_encoders: [
  swiftui: Phoenix.HTML.Engine
]

config :phoenix, template_engines: [
  neex: LiveViewNative.Engine
]

config :mime, :types, %{
  "text/swiftui" => ["swiftui"]
}

config :live_view_native_test_endpoint,
  formats: [:swiftui],
  otp_app: :live_view_native_swiftui,
  routes: [
    %{path: "/inline", module: LiveViewNativeTest.SwiftUI.InlineLive},
    %{path: "/template", module: LiveViewNativeTest.SwiftUI.TemplateLive}
  ]

config :phoenix, :plug_init_mode, :runtime

config :live_view_native_stylesheet,
  content: [
    swiftui: [
      "test/**/*.*"

    ]
  ],
  output: "priv/static/assets"
