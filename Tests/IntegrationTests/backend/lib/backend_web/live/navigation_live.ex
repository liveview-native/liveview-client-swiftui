defmodule BackendWeb.NavigationLive do
  use Phoenix.LiveView
  use LiveViewNative.LiveView

  def render(%{ platform_id: :swiftui } = assigns) do
    ~SWIFTUI"""
    <Button phx-click="push_navigate">push_navigate</Button>
    <Button phx-click="redirect">redirect</Button>
    <Button phx-click="push_navigate:replace">push_navigate:replace</Button>
    """
  end

  def handle_event("push_navigate", _params, socket) do
    {:noreply, push_navigate(socket, to: "/navigation-page2")}
  end

  def handle_event("push_navigate:replace", _params, socket) do
    {:noreply, push_navigate(socket, to: "/navigation-page2", replace: true)}
  end

  def handle_event("redirect", _params, socket) do
    {:noreply, redirect(socket, to: "/navigation-page2")}
  end
end

defmodule BackendWeb.NavigationPage2Live do
  use Phoenix.LiveView
  use LiveViewNative.LiveView

  def render(%{ platform_id: :swiftui } = assigns) do
    ~SWIFTUI"""
    <Text>Page 2</Text>
    """
  end
end
