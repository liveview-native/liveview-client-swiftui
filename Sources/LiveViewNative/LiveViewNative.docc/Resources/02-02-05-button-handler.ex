defmodule LvnTutorialWeb.CatsListLive do
  use LvnTutorialWeb, :live_view
  require EEx
  alias LvnTutorial.FavoritesStore

  EEx.function_from_file(
    :def,
    :render,
    "lib/lvn_tutorial_web/live/cats_list_live.ios.heex",
    [:assigns],
    engine: Phoenix.LiveView.HTMLEngine
  )

  @cats [
    "Clenil",
    "Flippers",
    "Jorts",
    "Kipper",
    "Lemmy",
    "Lissy",
    "Mikkel",
    "Minka",
    "Misty",
    "Nelly",
    "Ninj",
    "Pollito",
    "Siegfried",
    "Truman",
    "Washy"
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, cats_and_favorites: get_cats_and_favorites())}
  end

  def get_cats_and_favorites() do
    favorites = FavoritesStore.get_favorites()

    {favorites, non_favorites} =
      @cats
      |> Enum.map(fn name -> {name, Enum.member?(favorites, name)} end)
      |> Enum.split_with(fn {_, favorite} -> favorite end)

    favorites ++ non_favorites
  end

  def handle_event("toggle-favorite", %{"name" => name}, socket) do
    FavoritesStore.toggle_favorite(name)
    new = get_cats_and_favorites()
    {:noreply, assign(socket, cats_and_favorites: new)}
  end
end
