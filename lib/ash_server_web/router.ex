defmodule AshServerWeb.Router do
  use AshServerWeb, :router

  pipeline :graphql do
    plug :accepts, ["json"]
    plug ProperCase.Plug.SnakeCaseParams
    plug AshServerWeb.Plug.GraphqlContext
  end

  scope "/" do
    pipe_through [:graphql]
    forward "/graphql", Absinthe.Plug,
      schema: AshServerWeb.Schema,
      before_send: {AshServerWeb.Plug.BeforeSend, :handle_response}

    if Mix.env() == :dev do
      forward "/", Absinthe.Plug.GraphiQL,
        schema: AshServerWeb.Schema,
        before_send: {AshServerWeb.Plug.BeforeSend, :handle_response}
    end
  end
end
