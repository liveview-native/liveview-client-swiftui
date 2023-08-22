defmodule LiveViewNativeSwiftUi.Modifiers.ContentShape do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{Shape, ContentShapeKind}

  modifier_schema "content_shape" do
    field :kind, ContentShapeKind
    field :shape, Shape
    field :eo_fill, :boolean
  end

  def params(shape, params) when is_list(params) do
    with {:ok, _} <- ContentShapeKind.cast(shape) do
      [{:kind, shape} | params]
    else
      _ ->
        [{:shape, shape} | params]
    end
  end
  def params(params) do
    with {:ok, _} <- ContentShapeKind.cast(params) do
      [kind: params]
    else
      _ ->
        with {:ok, _} <- Shape.cast(params) do
          [shape: params]
        else
          _ ->
            params
        end
    end
  end
end
