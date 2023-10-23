defmodule LvnTutorialWeb.CatLive do
  use LvnTutorialWeb, :live_view
  use LiveViewNative.LiveView
  alias LvnTutorial.FavoritesStore

  def mount(%{"name" => name}, _session, socket) do
    {:ok, assign(socket, name: name, score: FavoritesStore.get_score(name))}
  end

  def render(%{format: :html} = assigns) do
    ~H""
  end

  def render(%{format: :swiftui} = assigns) do
    ~SWIFTUI"""
    <VStack modifiers={navigation_title(@native, title: @name)}>
      <AsyncImage url={"/images/cats/#{@name}.jpg"} modifiers={frame(@native, width: 300, height: 300)} />
    </VStack>
    """
  end

  def handle_event("change-score", score, socket) do
    FavoritesStore.set_score(socket.assigns.name, score)
    {:noreply, assign(socket, score: score)}
  end
end
