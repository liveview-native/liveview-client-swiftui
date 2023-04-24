defmodule LiveViewNativeSwiftUi.Modifiers.TextFieldStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "text_field_style" do
    field :style, Ecto.Enum, values: ~w(automatic plain rounded_border square_border)a
  end
end
