defmodule LiveViewNativeSwiftUi.Modifiers.DeleteDisabled do
  use LiveViewNativePlatform.Modifier

  modifier_schema "delete_disabled" do
    field :is_disabled, :boolean
  end

  def params(is_disabled) when is_boolean(is_disabled), do: [is_disabled: is_disabled]
  def params(params), do: params
end
