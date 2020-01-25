defmodule AshServerWeb.Middleware.QueryErrors do
  @behaviour Absinthe.Middleware

  def call(res, _) do
    with %{errors: [%Ecto.Query{} = query]} <- res do
      %{from: %{source: {_, queryable}}} = query
      schema = queryable |> Module.split() |> List.last()
      %{res | errors: ["#{schema} not found"]}
    end
  end
end
