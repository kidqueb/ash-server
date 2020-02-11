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

  def filter_integer_with(field, query) do
    field = Map.merge(%{eq: nil, gt: nil, gte: nil, lt: nil, lte: nil}, field)
    from q in query, where:
      q.field == type(^field.eq, :integer) or
      q.field < type(^field.lt, :integer) or
      q.field <= type(^field.lte, :integer) or
      q.field > type(^field.gt, :integer) or
      q.field >= type(^field.gte, :integer)
  end
end
