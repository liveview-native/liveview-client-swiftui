defmodule BackendWeb.PresentationModifiersLive do
  use Phoenix.LiveView
  use LiveViewNative.LiveView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, is_presented: false)}
  end

  def render(%{ platform_id: :swiftui } = assigns) do
    ~SWIFTUI"""
    <Button
      phx-click="present"
      modifiers={sheet(is_presented: @is_presented, content: :sheet_content)}
    >
      present
      <Text template={:sheet_content}>sheet</Text>
    </Button>
    """
  end

  def handle_event("present", _params, socket) do
    {:noreply, assign(socket, is_presented: true)}
  end
end
