defmodule LiveViewNativeSwiftUi.Modifiers.Rotation do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{Angle, UnitPoint}

  modifier_schema "rotation" do
    field :angle, Angle
    field :anchor, UnitPoint
  end
end
