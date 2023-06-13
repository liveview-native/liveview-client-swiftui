defmodule LiveViewNativeSwiftUi.Modifiers.Overlay do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{KeyName, ShapeStyle, Shape, EdgeSet, FillStyle}

  modifier_schema "overlay" do
    field :alignment, Ecto.Enum, values: ~w(
      bottom
      bottom_leading
      bottom_trailing
      center
      leading
      leading_last_text_baseline
      top
      top_leading
      top_trailing
      trailing
      trailing_first_text_baseline
    )a
    field :content, KeyName
    field :style, ShapeStyle
    field :shape, Shape
    field :ignores_safe_area_edges, EdgeSet
    field :fill_style, FillStyle
  end
end
