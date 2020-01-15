defmodule AshServer.Helpers.QueryHelpers do
  @moduledoc """
  Module of helpful functions and macros to be used throughout the app.
  """

  import Ecto.Query, warn: false

  def build_query(schema_module, args \\ %{}) do
    Enum.reduce(args, schema_module, fn
      {:filter, filter}, query ->
        schema_module.filter_with(query, filter)
      {:order_by, order}, query ->
        order_list_by(query, order)
    end)
  end

  def order_list_by(query, order) do
    order_list = []
    orderings = Enum.reduce(order, order_list, fn
      {k, v}, order_list ->
        order_list ++ [{String.to_atom(v), k}]
    end)

    order_by(query, ^orderings)
  end
end
