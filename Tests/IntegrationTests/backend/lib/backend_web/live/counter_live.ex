defmodule BackendWeb.CounterLive do
  use Phoenix.LiveView
  use LiveViewNative.LiveView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, count: 0)}
  end

  def render(%{ platform_id: :swiftui } = assigns) do
    ~SWIFTUI"""
    <Text><%= @count %></Text>
    <Button phx-click="increment">increment</Button>
    <Button phx-click="decrement">decrement</Button>
    """
  end

  def handle_event("increment", _params, socket) do
    {:noreply, assign(socket, count: socket.assigns.count + 1)}
  end

  def handle_event("decrement", _params, socket) do
    {:noreply, assign(socket, count: socket.assigns.count - 1)}
  end
end
