defmodule DemoWeb.SwiftUI.Home do
  use LiveViewNative.View,
    format: :swiftui


  def render(assigns, _interface) do
    ~LVN"""
    <Text>Hello from SwiftUI</Text>
    """
  end
end