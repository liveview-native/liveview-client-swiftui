defmodule LvnTutorialWeb.CatsListLive do
  use LvnTutorialWeb, :live_view
  use LiveViewNative.LiveView
  alias LvnTutorial.FavoritesStore

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
    {:ok, assign(socket, cats_and_favorites: get_cats_and_favorites())}
  end

  def render(%{layout: :html} = assigns) do
    ~H""
  end

  def render(%{layout: :swiftui} = assigns) do
    ~SWIFTUI"""
    <List>
      <%= for {name, favorite} <- @cats_and_favorites do %>
        <HStack id={name}>
          <AsyncImage url={"/images/cats/#{name}.jpg"} modifiers={frame(@native, width: 100, height: 100)} />
          <Text><%= name %></Text>
          <Spacer />
          <Button phx-click="toggle-favorite" phx-value-name={name}>
            <Image system-name={if favorite, do: "star.fill", else: "star"} symbol-color={if favorite, do: "#f3c51a", else: "#000000"} />
          </Button>
        </HStack>
      <% end %>
    </List>
    """
  end

  def get_cats_and_favorites() do
    favorites = FavoritesStore.get_favorites()

    {favorites, non_favorites} =
      @cats
      |> Enum.map(fn name -> {name, Enum.member?(favorites, name)} end)
      |> Enum.split_with(fn {_, favorite} -> favorite end)

    favorites ++ non_favorites
  end
end
