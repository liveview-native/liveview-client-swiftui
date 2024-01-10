defmodule LiveViewNative.SwiftUI.Component do
  defmacro __using__(_) do
    quote do
      import LiveViewNative.Component, only: [sigil_LVN: 2]
      import LiveViewNative.SwiftUI.Component, only: [sigil_SWIFTUI: 2]
    end
  end

  defmacro sigil_SWIFTUI(doc, modifiers) do
    IO.warn("~SWIFTUI is deprecated and will be removed for v0.4.0 Please change to ~LVN")

    quote do
      sigil_LVN(unquote(doc), unquote(modifiers))
    end
  end
end