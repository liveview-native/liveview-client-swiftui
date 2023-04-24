defmodule LiveViewNativeSwiftUi.Modifiers.DynamicTypeSize do
  use LiveViewNativePlatform.Modifier

  modifier_schema "dynamic_type_size" do
    field :size, Ecto.Enum, values: ~w(
      x_small
      small
      medium
      large
      x_large
      xx_large
      xxx_large
      accessibility_1
      accessibility_2
      accessibility_3
      accessibility_4
      accessibility_5
    )a
  end
end
