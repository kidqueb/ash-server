defmodule AshServerWeb.Schema.Queries.GetUserTest do
  use AshServerWeb.ConnCase
  import AshServer.Factory

  @query """
    query GetUser($id: ID!) {
      user(id: $id) {
        id
        email
      }
    }
  """

  test "finds a user by id", %{conn: conn} do
    user = insert(:user)
    response = post_gql(conn, %{
      query: @query,
      variables: %{id: user.id}
    })

    assert response["data"]["user"] == %{
      "id" => to_string(user.id),
      "email" => user.email,
    }
  end

  test "errors when finding nonexistent user by id", %{conn: conn} do
    response = post_gql(conn, %{
      query: @query,
      variables: %{id: 0}
    })

    assert response == %{
      "data" => %{"user" => nil},
      "errors" => [%{
        "locations" => [%{"column" => 0, "line" => 2}],
        "message" => "User not found",
        "path" => ["user"]
      }]
    }
  end
end
