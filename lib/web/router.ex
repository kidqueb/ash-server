defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :app do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug AppWeb.Context
  end

  # Dev outbox for email login
  if Mix.env == :dev do
    forward "/outbox", Bamboo.SentEmailViewerPlug
  end

  scope "/" do
    pipe_through [:app, :jwt_authenticated]
    forward "/graphql", Absinthe.Plug, schema: AppWeb.Schema

    if Mix.env == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL, schema: AppWeb.Schema
    end
  end
end
