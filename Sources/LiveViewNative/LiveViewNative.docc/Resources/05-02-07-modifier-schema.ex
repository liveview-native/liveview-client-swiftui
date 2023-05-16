defmodule LvnTutorialWeb.Modifiers.NavFavorite do
  use LiveViewNativePlatform.Modifier

  modifier_schema "nav_favorite" do
    field :is_favorite, :boolean
  end
end
