defmodule LvnTutorialWeb.CatsListLive do
  use LvnTutorialWeb, :live_view
  require EEx
  alias LvnTutorial.FavoritesStore

  # Omitted

  def mount(_params, _session, socket) do
    {:ok, assign(socket, cats: @cats)}
  end

  def get_cats_and_favorites() do
    favorites = FavoritesStore.get_favorites()

    {favorites, non_favorites} =
      @cats
      |> Enum.map(fn name -> {name, Enum.member?(favorites, name)} end)
      |> Enum.split_with(fn {_, favorite} -> favorite end)

    favorites ++ non_favorites
  end
end
