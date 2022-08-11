defmodule LvnTutorialWeb.CatsListLive do

  # Omitted

  def handle_event("toggle-favorite", %{"name" => name}, socket) do
    FavoritesStore.toggle_favorite(name)
    new = get_cats_and_favorites()
    {:noreply, assign(socket, cats_and_favorites: new)}
  end
end
