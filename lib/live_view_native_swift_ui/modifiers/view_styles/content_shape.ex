defmodule LiveViewNativeSwiftUi.Modifiers.ContentShape do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ContentShapeKind

  modifier_schema "content_shape" do
    field :kind, ContentShapeKind
    field :shape, Ecto.Enum, values: ~w(capsule circle container_relative_shape ellipse rectangle)a
    field :eo_fill, :boolean
  end
end
