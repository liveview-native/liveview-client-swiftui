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
end
