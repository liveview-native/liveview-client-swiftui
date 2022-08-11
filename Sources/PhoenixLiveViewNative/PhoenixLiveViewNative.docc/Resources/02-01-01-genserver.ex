defmodule LvnTutorial.FavoritesStore do
  use GenServer

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def get_favorites() do
    GenServer.call(__MODULE__, :get_favorites)
  end

  def toggle_favorite(name) do
    GenServer.call(__MODULE__, {:toggle_favorite, name})
  end

  # Server

  @impl true
  def init(_) do
    {:ok, []}
  end

  @impl true
  def handle_call(:get_favorites, _from, favorites) do
    {:reply, favorites, favorites}
  end

  @impl true
  def handle_call({:toggle_favorite, name}, _from, favorites) do
    new =
      if Enum.member?(favorites, name) do
        List.delete(favorites, name)
      else
        [name | favorites]
      end

    {:reply, new, new}
  end
end
