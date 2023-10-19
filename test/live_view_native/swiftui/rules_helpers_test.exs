defmodule LiveViewNative.SwiftUI.RulesHelpersTest do
  use ExUnit.Case
  alias LiveViewNative.SwiftUI.RulesHelpers

  describe "to_ime" do
    test "convert to the ime syntax for the AST" do
      assert RulesHelpers.to_ime("foobar") == {:., [], [nil, :foobar]}
    end
  end

  describe "event" do
    test "convert an event call to an AST node" do
      assert RulesHelpers.event("change") == {:__event__, [], ["change", []]}
      assert RulesHelpers.event("change", throttle: 1_000) == {:__event__, [], ["change", [throttle: 1_000]]}
    end
  end
end
