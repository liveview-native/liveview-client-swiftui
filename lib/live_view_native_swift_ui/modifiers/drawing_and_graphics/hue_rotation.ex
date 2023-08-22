defmodule LiveViewNativeSwiftUi.Modifiers.HueRotation do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.Angle

  modifier_schema "hue_rotation" do
    field :angle, Angle
  end

  def params(params) do
    with {:ok, _} <- Angle.cast(params) do
      [angle: params]
    else
      _ ->
        params
    end
  end
end
