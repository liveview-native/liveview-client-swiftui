defmodule LiveViewNativeSwiftUi.Modifiers.PickerStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "picker_style" do
    field(:style, Ecto.Enum, values: ~w(
      automatic
      inline
      menu
      navigation_link
      radio_group
      segmented
      wheel
      palette
    )a)
  end
end
