defmodule LiveViewNativeTest.SwiftUI.Layouts.SwiftUI do
  use LiveViewNative.Component,
    format: :swiftui

  import Phoenix.Controller, only: [get_csrf_token: 0]

  embed_templates "layouts_swiftui/*"
end