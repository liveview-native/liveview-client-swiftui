defmodule LiveViewNativeTest.SwiftUI.InlineLive.SwiftUI do
  use LiveViewNative.Component,
    format: :swiftui,
    as: :render

  def render(assigns, %{"target" => "watchos"}) do
    ~LVN"""
    <Text>WatchOS Target Inline SwiftUI Render {@count}</Text>
    """
  end

  def render(assigns, _interface) do
    ~LVN"""
    <Text>Inline SwiftUI Render {@count}</Text>
    """
  end
end

defmodule LiveViewNativeTest.SwiftUI.InlineLive do
  use Phoenix.LiveView,
    layout: false

  use LiveViewNative.LiveView,
    formats: [:swiftui],
    layouts: [
      swiftui: {LiveViewNativeTest.SwiftUI.Layouts.SwiftUI, :app}
    ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :count, 100)}
  end

  def render(assigns), do: ~H""
end
