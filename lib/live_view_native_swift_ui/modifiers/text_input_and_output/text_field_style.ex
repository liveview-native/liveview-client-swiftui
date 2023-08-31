defmodule LiveViewNativeSwiftUi.Modifiers.TextFieldStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "text_field_style" do
    field :style, Ecto.Enum, values: ~w(automatic plain rounded_border square_border)a
  end

  def params(style) when is_atom(style) and not is_boolean(style) and not is_nil(style), do: [style: style]
  def params(params), do: params
end
