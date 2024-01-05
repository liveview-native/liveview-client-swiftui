defmodule LiveViewNative.SwiftUI.Component do
  defmacro __using__(_) do
    modifiers = [~c(watchos), ~c(tvos), ~c(ios), ~c(ipados), ~c(macos), ~c(visionpro)]
    plugin = LiveViewNative.SwiftUI

    quote do
      import unquote(__MODULE__), only: [sigil_SWIFTUI: 2]

      LiveViewNative.Component.embed_sigil(unquote(modifiers), unquote(plugin))
    end
  end

  defmacro sigil_SWIFTUI(doc, modifiers) do
    IO.warn("~SWIFTUI is deprecated and will be removed for v0.4.0 Please change to ~LVN")

    quote do
      sigil_LVN(unquote(doc), unquote(modifiers))
    end
  end
end