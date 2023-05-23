defmodule LiveViewNativeSwiftUi.Modifiers.FindDisabled do
  use LiveViewNativePlatform.Modifier

  modifier_schema "find_disabled" do
    field :disabled, :boolean, default: true
  end
end
