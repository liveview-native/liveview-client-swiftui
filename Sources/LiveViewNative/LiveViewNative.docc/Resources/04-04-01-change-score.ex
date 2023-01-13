defmodule LvnTutorialWeb.CatLive do
  use LvnTutorialWeb, :live_view
  require EEx
  alias LvnTutorial.FavoritesStore

  EEx.function_from_file(
    :def,
    :render,
    "lib/lvn_tutorial_web/live/cat_live.ios.heex",
    [:assigns],
    engine: Phoenix.LiveView.HTMLEngine
  )

  def mount(%{"name" => name}, _session, socket) do
    {:ok, assign(socket, name: name, score: FavoritesStore.get_score(name))}
  end

  def handle_event("change-score", score, socket) do
    FavoritesStore.set_score(socket.assigns.name, score)
    {:noreply, assign(socket, score: score)}
  end
end
