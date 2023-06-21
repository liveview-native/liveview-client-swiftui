defmodule LiveViewNativeSwiftUi.Modifiers.Background do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.{KeyName, ShapeStyle, Shape, EdgeSet, FillStyle}

  modifier_schema "background" do
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

  def params({type, _} = style, [in: shape, fill_style: fill_style]) when is_atom(type), do: [style: style, shape: shape, fill_style: fill_style]
  def params({type, _} = style, [in: shape]) when is_atom(type), do: [style: style, shape: shape]
  def params([in: shape, fill_style: fill_style]), do: [shape: shape, fill_style: fill_style]
  def params([in: shape]), do: [shape: shape]
  def params({type, _} = style, [ignores_safe_area_edges: edges]) when is_atom(type), do: [style: style, ignores_safe_area_edges: edges]
  def params({type, _} = style) when is_atom(type), do: [style: style]
  def params(params), do: params
end
