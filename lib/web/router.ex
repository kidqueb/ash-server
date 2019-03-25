defmodule AppWeb.Router do
  use AppWeb, :router
  alias App.Guardian

  pipeline :app do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  # Dev outbox for email login
  if Mix.env == :dev do
    forward "/outbox", Bamboo.SentEmailViewerPlug
  end

  # Public Routes
  scope "/", AppWeb do
    pipe_through :app

    get "/login/:token", SessionController, :show, as: :login
    post "/login", SessionController, :create, as: :login
  end

  # Authenticated Routes
  scope "/", AppWeb do
    if Mix.env == :dev || Mix.env == :test do
      pipe_through [:app]
    else
      pipe_through [:app, :jwt_authenticated]
    end

    resources "/users", UserController, except: [:new, :edit] do
      # nested resources
    end
  end
end
