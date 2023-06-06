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

  def render(%{platform_id: :web} = assigns) do
    ~H""
  end

  def render(%{platform_id: :swiftui} = assigns) do
    ~SUI"""
    <List modifiers={navigation_title(@native, title: "Cats!")}>
      <%= for {name, favorite} <- @cats_and_favorites do %>
        <NavigationLink id={name} destination={"/cats/#{name}"}>
          <HStack>
            <AsyncImage url={"/images/cats/#{name}.jpg"} modifiers={frame(@native, width: 100, height: 100)} />
            <Text><%= name %></Text>
            <Spacer />
            <Button phx-click="toggle-favorite" phx-value-name={name}>
              <Image system-name={if favorite, do: "star.fill", else: "star"} symbol-color={if favorite, do: "#f3c51a", else: "#000000"} />
            </Button>
          </HStack>
        </NavigationLink>
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

  def handle_event("toggle-favorite", %{"name" => name}, socket) do
    FavoritesStore.toggle_favorite(name)
    new = get_cats_and_favorites()
    {:noreply, assign(socket, cats_and_favorites: new)}
  end
end
