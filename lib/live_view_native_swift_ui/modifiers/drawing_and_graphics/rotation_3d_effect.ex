defmodule LiveViewNativeSwiftUi.Modifiers.Rotation3DEffect do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Angle
  alias LiveViewNativeSwiftUi.Types.Rotation3DEffectAxis
  alias LiveViewNativeSwiftUi.Types.UnitPoint

  modifier_schema "rotation_3d_effect" do
    field :angle, Angle
    field :axis, Rotation3DEffectAxis
    field :anchor, UnitPoint
    field :anchor_z, :float, default: 0.0
    field :perspective, :float, default: 1.0
  end

  def params(angle, [axis: axis, anchor: anchor, anchor_z: anchor_z, perspective: perspective]),
    do: [
      angle: angle,
      axis: axis,
      anchor: anchor,
      anchor_z: anchor_z,
      perspective: perspective
    ]
  def params(params), do: params
end
