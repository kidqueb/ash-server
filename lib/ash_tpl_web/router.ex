defmodule AshTplWeb.Router do
  use AshTplWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug ProperCase.Plug.SnakeCaseParams
    plug AshTplWeb.AuthPlug, otp_app: :ash_tpl
  end

  pipeline :api_protected do
    plug AshTplWeb.GraphqlContext
  end

  scope "/auth", AshTplWeb do
    pipe_through :api

    resources "/signup", RegistrationController, singleton: true, only: [:create]
    resources "/login", SessionController, singleton: true, only: [:create, :delete]
    post "/renew", SessionController, :renew
    get "/me", SessionController, :me
  end

  scope "/" do
    pipe_through [:api, :api_protected]
    forward "/graphql", Absinthe.Plug, schema: AshTplWeb.Schema

    if Mix.env() == :dev do
      forward "/", Absinthe.Plug.GraphiQL, schema: AshTplWeb.Schema
    end
  end
end
