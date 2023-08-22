defmodule LiveViewNativeSwiftUi.Modifiers.KeyboardShortcut do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativePlatform.Modifier.Types.EventModifier
  alias LiveViewNativeSwiftUi.Types.KeyEquivalent

  modifier_schema "keyboard_shortcut" do
    field :key, KeyEquivalent
    field :modifiers, EventModifier
  end

  def params(key, params) when is_list(params), do: [{:key, key} | params]
  def params(params) do
    with {:ok, _} <- KeyEquivalent.cast(params) do
      [key: params]
    else
      _ ->
        params
    end
  end
end
