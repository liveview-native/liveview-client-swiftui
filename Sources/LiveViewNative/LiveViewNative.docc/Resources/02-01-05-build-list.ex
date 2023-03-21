defmodule LvnTutorialWeb.CatsListLive do
  use LvnTutorialWeb, :live_view
  use LiveViewNative.LiveView
  alias LvnTutorial.FavoritesStore

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
    {:ok, assign(socket, cats: @cats)}
  end

  def render(assigns) do
    render_native(assigns)
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
