defmodule LvnTutorialWeb.CatLive do
  use LvnTutorialWeb, :live_view
  use LiveViewNative.LiveView

  def mount(%{"name" => name}, _session, socket) do
    {:ok, assign(socket, name: name)}
  end

  def render(%{platform_id: :web} = assigns) do
    ~H""
  end

  def render(assigns) do
    render_native(assigns)
  end
end
