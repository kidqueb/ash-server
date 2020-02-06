defmodule AshServerWeb.Router do
  use AshServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug ProperCase.Plug.SnakeCaseParams
  end

  scope "/" do
    pipe_through [:api]
    forward "/graphql", Absinthe.Plug, schema: AshServerWeb.Schema

    if Mix.env() == :dev do
      forward "/", Absinthe.Plug.GraphiQL, schema: AshServerWeb.Schema
    end
  end
end
