defmodule LiveViewNativeTest.SwiftUI.TemplateLive.SwiftUI do
  use LiveViewNative.Component,
    format: :swiftui,
    as: :render
end

defmodule LiveViewNativeTest.SwiftUI.TemplateLive do
  use Phoenix.LiveView,
    layout: false

  use LiveViewNative.LiveView,
    formats: [:swiftui],
    layouts: [
      swiftui: {LiveViewNativeTest.SwiftUI.Layouts.SwiftUI, :app}
    ],
    dispatch_to: &Module.concat/2

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :count, 100)}
  end

  def render(assigns), do: ~H""
end
