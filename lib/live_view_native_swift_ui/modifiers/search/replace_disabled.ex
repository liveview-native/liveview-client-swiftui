defmodule LiveViewNativeSwiftUi.Modifiers.ReplaceDisabled do
  use LiveViewNativePlatform.Modifier

  modifier_schema "replace_disabled" do
    field :disabled, :boolean, default: true
  end

  def params(disabled) when is_boolean(disabled), do: [disabled: disabled]
end
