defmodule LiveViewNativeSwiftUi.Modifiers.ToolbarBackground do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ShapeStyle

  modifier_schema "toolbar_background" do
    field :style, ShapeStyle
    field :visibility, Ecto.Enum, values: ~w(automatic hidden visible)a
    field :bars, Ecto.Enum, values: ~w(automatic bottom_bar navigation_bar tab_bar window_toolbar)a
  end

  def params(visibility, params) when is_atom(visibility) and not is_boolean(visibility) and not is_nil(visibility) and is_list(params), do: [{:visibility, visibility} | params]
  def params(style, params) when is_list(params), do: [{:style, style} | params]
  def params(params), do: params
end
