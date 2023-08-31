defmodule LiveViewNativeSwiftUi.Modifiers.Focusable do
  use LiveViewNativePlatform.Modifier

  modifier_schema "focusable" do
    field :is_focusable, :boolean, default: true
  end

  def params(is_focusable) when is_boolean(is_focusable), do: [is_focusable: is_focusable]
  def params(params), do: params
end
