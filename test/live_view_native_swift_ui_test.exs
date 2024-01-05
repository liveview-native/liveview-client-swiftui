defmodule LiveViewNative.SwiftUITest do
  use ExUnit.Case

  alias LiveViewNative.SwiftUI

  test "implements the correct behavior callbacks" do
    assert SwiftUI.format() == :swiftui
    assert SwiftUI.template_engine() == LiveViewNative.Engine
    assert SwiftUI.tag_handler(nil) == LiveViewNative.TagEngine
    assert SwiftUI.view() == SwiftUI.View
  end
end
