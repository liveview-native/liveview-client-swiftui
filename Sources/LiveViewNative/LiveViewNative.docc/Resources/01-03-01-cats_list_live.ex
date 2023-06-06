defmodule LvnTutorialWeb.CatsListLive do
  use LvnTutorialWeb, :live_view
  use LiveViewNative.LiveView

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

  def render(%{platform_id: :web} = assigns) do
    ~H""
  end

  def render(%{platform_id: :swiftui} = assigns) do
    ~SUI"""
    <List>
      <%= for name <- @cats do %>
        <Text id={name}><%= name %></Text>
      <% end %>
    </List>
    """
  end
end
