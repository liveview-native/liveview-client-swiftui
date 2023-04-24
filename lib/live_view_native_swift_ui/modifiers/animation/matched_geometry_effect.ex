defmodule LiveViewNativeSwiftUi.Modifiers.MatchedGeometryEffect do
  use LiveViewNativePlatform.Modifier
  alias LiveViewNativeSwiftUi.Types.Namespace
  alias LiveViewNativeSwiftUi.Types.UnitPoint

  modifier_schema "matched_geometry_effect" do
    field :id, :string
    field :namespace, Namespace
    field :properties, Ecto.Enum, values: ~w(frame position size)a, default: :frame
    field :anchor, UnitPoint
    field :is_source, :boolean, default: true
  end
end
