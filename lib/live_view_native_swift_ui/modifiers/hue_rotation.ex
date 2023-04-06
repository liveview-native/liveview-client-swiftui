defmodule LiveViewNativeSwiftUi.Modifiers.HueRotation do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Angle

  modifier_schema "hue_rotation" do
    field :angle, Angle
  end
end
