Mix.install([
  {:live_view_native_swift_ui, path: "."},
  {:live_view_native, git: "https://github.com/liveview-native/live_view_native", branch: "main"},
  {:html_entities, "~> 0.5"}
])

defmodule ModifierEncoder do
  @native LiveViewNativePlatform.context(%LiveViewNativeSwiftUi.Platform{})

  use LiveViewNative.Extensions.Modifiers,
    custom_modifiers: [],
    platform_modifiers: @native.platform_modifiers

  defmacro quote_argv() do
    System.argv()
    |> hd()
    |> String.replace(~r'///', "")
    |> Code.string_to_quoted!()
  end

  def encode() do
    IO.write(
      Phoenix.HTML.Safe.to_iodata(quote_argv().modifiers)
      |> IO.iodata_to_binary
      |> HtmlEntities.decode
    )
  end
end

ModifierEncoder.encode()
