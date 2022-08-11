defmodule LvnTutorialWeb.CatLive do
  use LvnTutorialWeb, :live_view
  require EEx

  EEx.function_from_file(
    :def,
    :render,
    "lib/lvn_tutorial_web/live/cat_live.ios.heex",
    [:assigns],
    engine: Phoenix.LiveView.HTMLEngine
  )

  def mount(%{"name" => name}, _session, socket) do
    {:ok, assign(socket, name: name)}
  end
end
