defmodule LiveViewNative.SwiftUI do
  def format, do: :swiftui
  def template_engine, do: LiveViewNative.Engine

  def tag_handler(_target) do
    LiveViewNative.TagEngine
  end
end
