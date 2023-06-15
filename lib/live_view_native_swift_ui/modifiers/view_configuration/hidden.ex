defmodule LiveViewNativeSwiftUi.Modifiers.Hidden do
  use LiveViewNativePlatform.Modifier

  modifier_schema "hidden" do
    field :is_active, :boolean
  end

  def params(is_active) when is_boolean(is_active), do: [is_active: is_active]
  def params(params), do: params
end
