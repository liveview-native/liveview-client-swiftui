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

  def get_score(name) do
    GenServer.call(__MODULE__, {:get_score, name})
  end

  def set_score(name, score) do
    GenServer.call(__MODULE__, {:set_score, name, score})
  end

  # Server

  @impl true
  def init(_) do
    {:ok, {[], %{}}}
  end

  @impl true
  def handle_call(:get_favorites, _from, {favorites, _} = state) do
    {:reply, favorites, state}
  end

  @impl true
  def handle_call({:toggle_favorite, name}, _from, {favorites, scores}) do
    new =
      if Enum.member?(favorites, name) do
        List.delete(favorites, name)
      else
        [name | favorites]
      end

    {:reply, new, {new, scores}}
  end

  @impl true
  def handle_call({:get_score, name}, _from, {_, scores} = state) do
    {:reply, Map.get(scores, name, 0), state}
  end

  @impl true
  def handle_call({:set_score, name, score}, _from, {favorites, scores}) do
    new = Map.put(scores, name, score)
    {:reply, new, {favorites, new}}
  end
end
