defmodule LiveViewNative.SwiftUI do
  @behaviour LiveViewNative

  @impl true
  def format, do: :swiftui

  @impl true
  def module_suffix, do: :SwiftUI

  @impl true
  def template_engine, do: LiveViewNative.Engine

  @impl true
  def tag_handler(_target), do: LiveViewNative.TagEngine

  @impl true
  def component, do: LiveViewNative.SwiftUI.Component
end
