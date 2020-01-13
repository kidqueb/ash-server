defmodule AshServerWeb.Router do
  use AshServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug ProperCase.Plug.SnakeCaseParams
    plug AshServerWeb.AuthPlug, otp_app: :ash_server
  end

  pipeline :api_protected do
    plug AshServerWeb.GraphqlContext
  end

  scope "/auth", AshServerWeb do
    pipe_through :api

    resources "/signup", RegistrationController, singleton: true, only: [:create]
    resources "/login", SessionController, singleton: true, only: [:create, :delete]
    post "/renew", SessionController, :renew
    get "/me", SessionController, :me
  end

  scope "/" do
    pipe_through [:api, :api_protected]
    forward "/graphql", Absinthe.Plug, schema: AshServerWeb.Schema

    if Mix.env() == :dev do
      forward "/", Absinthe.Plug.GraphiQL, schema: AshServerWeb.Schema
    end
  end
end
