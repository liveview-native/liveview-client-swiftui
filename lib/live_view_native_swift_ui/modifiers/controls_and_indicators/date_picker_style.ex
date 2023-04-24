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
end
