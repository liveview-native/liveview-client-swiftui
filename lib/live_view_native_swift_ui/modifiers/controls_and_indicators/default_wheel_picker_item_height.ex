defmodule LiveViewNativeSwiftUi.Modifiers.DefaultWheelPickerItemHeight do
  use LiveViewNativePlatform.Modifier

  modifier_schema "default_wheel_picker_item_height" do
    field(:height, :float)
  end

  def params(height) when is_number(height), do: [height: height]
  def params(params), do: params
end
