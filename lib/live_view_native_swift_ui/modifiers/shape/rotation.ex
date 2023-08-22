defmodule LiveViewNativeSwiftUi.Modifiers.Rotation do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{Angle, UnitPoint}

  modifier_schema "rotation" do
    field :angle, Angle
    field :anchor, UnitPoint
  end

  def params(angle, params) when is_list(params), do: [{:angle, angle} | params]
  def params(params) do
    with {:ok, _} <- Angle.cast(params) do
      [angle: params]
    else
      _ ->
        params
    end
  end
end
