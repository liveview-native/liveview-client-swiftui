Mix.install([
  {:live_view_native_swift_ui, path: "."},
  {:live_view_native, git: "https://github.com/liveview-native/live_view_native", branch: "main"},
])

defmodule ModifierEncoder do
  @native LiveViewNativePlatform.context(%LiveViewNativeSwiftUi.Platform{})

  use LiveViewNative.Extensions.Modifiers,
    custom_modifiers: [],
    platform_modifiers: @native.platform_modifiers

  defmacro encode() do
    Code.string_to_quoted!(hd(System.argv()))
  end

  def encode!() do
    IO.write(Phoenix.HTML.Safe.to_iodata(encode().modifiers) |> IO.iodata_to_binary)
  end
end

ModifierEncoder.encode!()
