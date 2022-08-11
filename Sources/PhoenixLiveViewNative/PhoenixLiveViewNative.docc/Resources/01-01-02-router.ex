defmodule LvnTutorialWeb.Router do
  use LvnTutorialWeb, :router
  
  # Omitted

  scope "/", LvnTutorialWeb do
    pipe_through :browser

    live "/cats", CatsListLive
  end
end
