defmodule LiveViewNativeSwiftUi.Modifiers.ToolbarBackground do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativeSwiftUi.Types.ShapeStyle

  modifier_schema "toolbar_background" do
    field :style, ShapeStyle
    field :visibility, Ecto.Enum, values: ~w(automatic hidden visible)a
    field :bars, Ecto.Enum, values: ~w(automatic bottom_bar navigation_bar tab_bar window_toolbar)a
  end
end
