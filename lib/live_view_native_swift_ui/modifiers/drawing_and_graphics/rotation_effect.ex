defmodule LiveViewNativeSwiftUi.Modifiers.RotationEffect do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Angle
  alias LiveViewNativeSwiftUi.Types.UnitPoint

  modifier_schema "rotation_effect" do
    field :angle, Angle
    field :anchor, UnitPoint
  end

  def params(angle, [anchor: anchor]), do: [angle: angle, anchor: anchor]
  def params(params) do
    with {:ok, _} <- Angle.cast(params) do
      [angle: params, anchor: :center]
    else
      _ ->
        params
    end
  end
end
