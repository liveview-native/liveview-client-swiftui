defmodule LvnTutorialWeb.CatLive do
  use LvnTutorialWeb, :live_view
  use LiveViewNative.LiveView
  alias LvnTutorial.FavoritesStore

  def mount(%{"name" => name}, _session, socket) do
    {:ok, assign(socket, name: name, score: FavoritesStore.get_score(name))}
  end

  def render(assigns) do
    render_native(assigns)
  end

  def handle_event("change-score", score, socket) do
    FavoritesStore.set_score(socket.assigns.name, score)
    {:noreply, assign(socket, score: score)}
  end
end
