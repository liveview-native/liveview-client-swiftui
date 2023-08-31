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

  def params([id: id, in: namespace, properties: properties, anchor: anchor, is_source: is_source]),
    do: [
      id: id,
      namespace: namespace,
      properties: properties,
      anchor: anchor,
      is_source: is_source
    ]
  def params(params), do: params
end
