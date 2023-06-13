defmodule LiveViewNativeSwiftUi.Modifiers.ContentShape do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{Shape, ContentShapeKind}

  modifier_schema "content_shape" do
    field :kind, ContentShapeKind
    field :shape, Shape
    field :eo_fill, :boolean
  end
end
