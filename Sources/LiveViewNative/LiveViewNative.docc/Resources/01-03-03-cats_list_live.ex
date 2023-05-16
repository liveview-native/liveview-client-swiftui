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
    ~Z"""
    <List>
      <%= for name <- @cats do %>
        <HStack id={name}>
          <AsyncImage url={"/images/cats/#{name}.jpg"} modifiers={frame(@native, width: 100, height: 100)} />
          <Text><%= name %></Text>
        </HStack>
      <% end %>
    </List>
    """swiftui
  end
end
