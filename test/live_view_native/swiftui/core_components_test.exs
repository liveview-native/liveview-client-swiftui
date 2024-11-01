defmodule LiveViewNative.SwiftUI.CoreComponentsTest do
  use ExUnit.Case

  File.read!("priv/templates/lvn.swiftui.gen/core_components.ex")
  |> EEx.eval_string([
    context: %{
      web_module: LiveViewNativeTest,
      module_suffix: SwiftUI
    },
    assigns: %{
      live_form?: true,
      gettext: true,
      version: Application.spec(:live_view_native_swiftui)[:vsn]
    }
  ])
  |> Code.eval_string()

  describe "input/1" do

  end

  describe "error/1" do

  end

  describe "header/1" do

  end

  describe "modal/1" do

  end

  describe "flash/1" do

  end

  describe "flash_group/1" do

  end

  describe "simple_form/1" do

  end

  describe "button/1" do

  end

  describe "table" do

  end

  describe "list/1" do

  end

  describe "image/1" do

  end

  describe "translate_error/1" do

  end

  describe "translate_errors/1" do

  end
end
