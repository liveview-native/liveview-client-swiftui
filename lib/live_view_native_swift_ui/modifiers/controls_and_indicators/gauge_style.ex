defmodule LiveViewNativeSwiftUi.Modifiers.GaugeStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "gauge_style" do
    field(:style, Ecto.Enum, values: ~w(
      automatic
      accessory_circular_capacity
      accessory_linear_capacity
      accessory_circular
      linear_capacity
      accessory_linear
    )a)
  end

  def params(style) when is_atom(style) and not is_boolean(style) and not is_nil(style), do: [style: style]
  def params(params), do: params
end
