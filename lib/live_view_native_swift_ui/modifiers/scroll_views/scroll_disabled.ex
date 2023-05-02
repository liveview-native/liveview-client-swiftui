defmodule LiveViewNativeSwiftUi.Modifiers.ScrollDisabled do
  use LiveViewNativePlatform.Modifier

  modifier_schema "scroll_disabled" do
    field :disabled, :boolean
  end
end
