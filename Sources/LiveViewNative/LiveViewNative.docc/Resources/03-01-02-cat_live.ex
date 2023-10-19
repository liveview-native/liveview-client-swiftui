defmodule LvnTutorialWeb.CatLive do
  use LvnTutorialWeb, :live_view
  use LiveViewNative.LiveView

  def mount(%{"name" => name}, _session, socket) do
    {:ok, assign(socket, name: name)}
  end

  def render(%{layout: :html} = assigns) do
    ~H""
  end

  def render(%{layout: :swiftui} = assigns) do
    ~SWIFTUI"""
    <VStack modifiers={navigation_title(@native, title: @name)}>
      <AsyncImage url={"/images/cats/#{@name}.jpg"} modifiers={frame(@native, width: 300, height: 300)} />
    </VStack>
    """
  end
end
