defmodule LiveViewNativeSwiftUi.Modifiers.DatePickerStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "date_picker_style" do
    field(:style, Ecto.Enum, values: ~w(
      automatic
      compact
      graphical
      wheel
      field
      stepper_field
    )a)
  end

  def params(style) when is_atom(style) and not is_boolean(style) and not is_nil(style), do: [style: style]
  def params(params), do: params
end
