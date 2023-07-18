defmodule LiveViewNativeSwiftUi.Modifiers.LayoutPriority do
  use LiveViewNativePlatform.Modifier

  modifier_schema "layout_priority" do
    field :value, :float
  end

  def params(value) when is_number(value), do: [value: value]
  def params(params), do: params
end
