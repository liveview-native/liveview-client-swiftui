defmodule LiveViewNativeSwiftUi.Modifiers.ScrollDisabled do
  use LiveViewNativePlatform.Modifier

  modifier_schema "scroll_disabled" do
    field :disabled, :boolean
  end

  def params(disabled) when is_boolean(disabled), do: [disabled: disabled]
  def params(params), do: params
end
