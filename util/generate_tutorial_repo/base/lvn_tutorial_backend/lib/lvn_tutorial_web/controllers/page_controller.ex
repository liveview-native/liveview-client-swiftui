defmodule LvnTutorialWeb.PageController do
  use LvnTutorialWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
