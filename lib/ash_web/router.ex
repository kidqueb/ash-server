defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug ProperCase.Plug.SnakeCaseParams
    plug AppWeb.AuthPlug, otp_app: :app
  end

  pipeline :api_protected do
    plug AppWeb.GraphqlContext
  end

  scope "/auth", AppWeb do
    pipe_through :api

    resources "/signup", RegistrationController, singleton: true, only: [:create]
    resources "/login", SessionController, singleton: true, only: [:create, :delete]
    post "/renew", SessionController, :renew
    get "/me", SessionController, :me
  end

  scope "/" do
    pipe_through [:api, :api_protected]
    forward "/graphql", Absinthe.Plug, schema: AppWeb.Schema

    if Mix.env() == :dev do
      forward "/", Absinthe.Plug.GraphiQL, schema: AppWeb.Schema
    end
  end
end
