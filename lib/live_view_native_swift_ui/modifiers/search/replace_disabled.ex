defmodule LiveViewNativeSwiftUi.Modifiers.ReplaceDisabled do
  use LiveViewNativePlatform.Modifier

  modifier_schema "replace_disabled" do
    field :disabled, :boolean, default: true
  end
end
