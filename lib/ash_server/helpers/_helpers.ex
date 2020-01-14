defmodule AshServer.Helpers do
  @moduledoc """
  Module of helpful functions and macros to be used throughout the app.
  """

  import Ecto.Query, warn: false

  def order_list_by(query, order) do
    order_list = []
    orderings = Enum.reduce(order, order_list, fn
      {k, v}, order_list ->
        order_list ++ [{String.to_atom(v), k}]
    end)

    order_by(query, ^orderings)
  end
end
