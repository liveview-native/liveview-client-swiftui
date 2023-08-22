defmodule LiveViewNativeSwiftUi.Modifiers.ToolbarVisibility do
  use LiveViewNativePlatform.Modifier

  modifier_schema "toolbar_visibility" do
    field :visibility, Ecto.Enum, values: ~w(automatic hidden visible)a
    field :bars, Ecto.Enum, values: ~w(automatic bottom_bar navigation_bar tab_bar window_toolbar)a
  end

  def params(visibility, params) when is_list(params), do: [{:visibility, visibility} | params]
  def params(params), do: params
end
