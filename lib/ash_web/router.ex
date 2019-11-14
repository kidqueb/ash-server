defmodule AshWeb.Router do
  use AshWeb, :router

  pipeline :ash do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug AshWeb.Context
  end

  # Dev outbox for email login
  if Mix.env() == :dev do
    forward "/outbox", Bamboo.SentEmailViewerPlug
  end

  scope "/" do
    pipe_through [:ash, :jwt_authenticated]
    forward "/graphql", Absinthe.Plug, schema: AshWeb.Schema

    if Mix.env() == :dev do
      forward "/", Absinthe.Plug.GraphiQL, schema: AshWeb.Schema
    end
  end
end
