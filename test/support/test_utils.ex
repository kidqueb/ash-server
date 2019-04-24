defmodule Ash.TestUtils do
  @moduledoc """
  A set of utility functions for making tests a little easier to read/manage.
  """

  use Phoenix.ConnTest
  @endpoint AshWeb.Endpoint # We need to set the default endpoint for ConnTest


  @doc """
  Takes a list of items and returns a list of just their IDs.
  Useful when testing creation/listing of multiple items.
  """
  def to_id_array(arr) do
    Enum.map(arr, fn i -> %{"id" => to_string(i.id)} end)
  end

  @doc """
  Posts a query to the graphql endpoint and returns the json response.
  """
  def post_gql(conn, options) do
    conn
    |> post("/graphql", build_query(options[:query], options[:variables]))
    |> json_response(200)
  end

  defp build_query(query, variables) do
    %{"query" => query, "variables" => variables}
  end
end
