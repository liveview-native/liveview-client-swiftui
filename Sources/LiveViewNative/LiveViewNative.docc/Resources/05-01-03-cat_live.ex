defmodule LvnTutorialWeb.CatLive do
  use LvnTutorialWeb, :live_view
  use LiveViewNative.LiveView
  alias LvnTutorial.FavoritesStore

  def mount(%{"name" => name}, _session, socket) do
    {:ok,
     assign(socket,
       name: name,
       favorite: Enum.member?(FavoritesStore.get_favorites(), name),
       score: FavoritesStore.get_score(name)
     )}
  end

  def render(%{platform_id: :web} = assigns) do
    ~H""
  end

  def render(%{platform_id: :swiftui} = assigns) do
    ~SUI"""
    <VStack modifiers={navigation_title(@native, title: @name)}>
      <AsyncImage url={"/images/cats/#{@name}.jpg"} modifiers={frame(@native, width: 300, height: 300)} />
      <CatRating score={@score} />
    </VStack>
    """
  end

  def handle_event("change-score", score, socket) do
    FavoritesStore.set_score(socket.assigns.name, score)
    {:noreply, assign(socket, score: score)}
  end

  def handle_event("toggle-favorite", _, socket) do
    new = FavoritesStore.toggle_favorite(socket.assigns.name)
    {:noreply, assign(socket, favorite: Enum.member?(new, socket.assigns.name))}
  end
end
