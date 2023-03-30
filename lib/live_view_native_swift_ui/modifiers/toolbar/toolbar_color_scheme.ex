defmodule LiveViewNativeSwiftUi.Modifiers.ToolbarColorScheme do
  use LiveViewNativePlatform.Modifier

  modifier_schema "toolbar_color_scheme" do
    field :color_scheme, Ecto.Enum, values: ~w(dark light)a
    field :bars, Ecto.Enum, values: ~w(automatic bottom_bar navigation_bar tab_bar window_toolbar)a
  end
end
