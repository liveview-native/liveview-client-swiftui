defmodule LiveViewNativeSwiftUi.Modifiers.KeyboardShortcut do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativePlatform.Types.EventModifier
  alias LiveViewNativeSwiftUi.Types.KeyEquivalent

  modifier_schema "keyboard_shortcut" do
    field :key, KeyEquivalent
    field :modifiers, EventModifier
  end
end
