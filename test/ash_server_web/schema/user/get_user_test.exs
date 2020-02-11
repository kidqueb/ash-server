defmodule AshServerWeb.Schema.GetUserTest do
  use AshServerWeb.ConnCase

  @query """
    query GetUser($id: ID!) {
      user(id: $id) {
        id
        email
      }
    }
  """

  @tag :authenticated
  test "finds a user by id", %{conn: conn, current_user: current_user} do
    response = post_gql(conn, %{
      query: @query,
      variables: %{id: current_user.id}
    })

    assert response["data"]["user"] == %{
      "id" => to_string(current_user.id),
      "email" => current_user.email,
    }
  end
end
