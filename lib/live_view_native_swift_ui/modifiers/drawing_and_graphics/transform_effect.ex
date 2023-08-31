defmodule LiveViewNativeSwiftUi.Modifiers.TransformEffect do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.AffineTransform

  modifier_schema "transform_effect" do
    field :transform, AffineTransform
  end

  def params(params) do
    with {:ok, _} <- AffineTransform.cast(params) do
      [transform: params]
    else
      _ ->
        params
    end
  end
end
