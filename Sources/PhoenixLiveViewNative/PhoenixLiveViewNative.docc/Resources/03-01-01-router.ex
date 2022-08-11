defmodule LvnTutorialWeb.Router do
  use LvnTutorialWeb, :router
  
  # Omitted

  scope "/", LvnTutorialWeb do
    pipe_through :browser

    live_session :cats do
      live "/cats", CatsListLive
      live "/cats/:name", CatLive
    end
  end
end
