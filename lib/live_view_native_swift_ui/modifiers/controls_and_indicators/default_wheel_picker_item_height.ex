defmodule LiveViewNativeSwiftUi.Modifiers.DefaultWheelPickerItemHeight do
  use LiveViewNativePlatform.Modifier

  modifier_schema "default_wheel_picker_item_height" do
    field(:height, :float)
  end
end
