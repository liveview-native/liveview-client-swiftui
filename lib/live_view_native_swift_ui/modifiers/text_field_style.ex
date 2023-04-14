defmodule LiveViewNativeSwiftUi.Modifiers.TextFieldStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "text_field_style" do
    field :style, Ecto.Enum, values: ~w(automatic plain rounded-border square-border)a
  end
end
