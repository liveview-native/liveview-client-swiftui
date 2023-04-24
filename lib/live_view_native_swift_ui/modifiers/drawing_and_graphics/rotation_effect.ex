defmodule LiveViewNativeSwiftUi.Modifiers.RotationEffect do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Angle
  alias LiveViewNativeSwiftUi.Types.UnitPoint

  modifier_schema "rotation_effect" do
    field :angle, Angle
    field :anchor, UnitPoint
  end
end
