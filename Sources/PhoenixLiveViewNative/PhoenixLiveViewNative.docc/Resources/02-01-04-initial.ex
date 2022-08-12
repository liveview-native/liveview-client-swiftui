defmodule LvnTutorialWeb.CatsListLive do
  use LvnTutorialWeb, :live_view
  require EEx

  # Omitted

  def mount(_params, _session, socket) do
    {:ok, assign(socket, cats: @cats)}
  end
end
