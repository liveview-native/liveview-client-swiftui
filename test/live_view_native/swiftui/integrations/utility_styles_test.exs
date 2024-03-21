defmodule LiveViewNative.SwiftUI.UtilityStylesTest do
  use ExUnit.Case, async: false
  describe "stylesheet output" do
    test "utility classes work" do
      assert AppSheet.class("padding") == {:padding, [], []}
    end

    test "should not compile to file" do
      refute File.exists?("priv/static/assets/utility.styles")
    end
  end
end
