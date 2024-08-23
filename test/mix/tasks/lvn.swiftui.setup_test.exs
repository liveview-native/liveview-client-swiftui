defmodule Mix.Tasks.Lvn.Swiftui.SetupTest do
  use ExUnit.Case

  import Mix.Lvn.TestHelper
  import ExUnit.CaptureIO

  alias Mix.Tasks.Lvn.Swiftui.Setup.Gen

  @macos? :os.type() == {:unix, :darwin}

  setup do
    Mix.Task.clear()
    :ok
  end

  describe "when a single app" do
    test "copies the core components file into the project and generates a new xcode project", config do
      in_tmp_live_project config.test, fn ->
        capture_io(fn ->
          Gen.run([])
        end)
        assert_file "lib/live_view_native_swiftui_web/components/core_components.swiftui.ex", fn file ->
          assert file =~ "LiveViewNativeSwiftuiWeb.CoreComponents.SwiftUI"
          assert file =~ "import LiveViewNative.LiveForm.Component"
        end
        if @macos? do
          assert_file "native/swiftui/LiveViewNativeSwiftui/LiveViewNativeSwiftui.swift"
        end
      end
    end
  end

  describe "when an umbrella app" do
    test "copies the core components file into the project and generates a new xcode project", config do
      in_tmp_live_umbrella_project config.test, fn ->
        File.cd!("live_view_native_swiftui_web", fn ->
          capture_io(fn ->
            Gen.run([])
          end)
          assert_file "lib/live_view_native_swiftui_web/components/core_components.swiftui.ex", fn file ->
            assert file =~ "LiveViewNativeSwiftuiWeb.CoreComponents.SwiftUI"
            assert file =~ "import LiveViewNative.LiveForm.Component"
          end
          if @macos? do
            assert_file "native/swiftui/LiveViewNativeSwiftui/LiveViewNativeSwiftui.swift"
          end
        end)
      end
    end
  end
end
