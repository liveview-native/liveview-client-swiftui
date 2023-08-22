defmodule LiveViewNativeSwiftUi.Modifiers.ClipShape do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{Shape, FillStyle}

  modifier_schema "clip_shape" do
    field :shape, Shape
    field :style, FillStyle
  end

  def params(shape, [style: style]), do: [shape: shape, style: style]
  def params(params) do
    with {:ok, _} <- Shape.cast(params) do
      [shape: params, style: nil]
    else
      _ ->
        params
    end
  end
end
