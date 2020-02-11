defmodule AshServerWeb.Schema.DeleteUserTest do
  use AshServerWeb.ConnCase
  import AshServer.Factory

  @query """
    mutation DeleteUser($id: ID!) {
      deleteUser(id: $id) {
        id
      }
    }
  """

  @tag :authenticated
  test "users can delete themselves", %{conn: conn, current_user: current_user} do
    response = post_gql(conn, %{
      query: @query,
      variables: %{id: current_user.id}
    })

    assert response == %{
      "data" => %{
        "deleteUser" => %{
          "id" => to_string(current_user.id)
        }
      }
    }
  end

  @tag :authenticated
  test "other users cannot delete a different user", %{conn: conn} do
    user = insert(:user)
    response = post_gql(conn, %{
      query: @query,
      variables: %{id: user.id}
    })

    assert response == %{
      "data" => %{"deleteUser" => nil},
      "errors" => [%{
        "locations" => [%{"column" => 0, "line" => 2}],
        "message" => "unauthorized",
        "path" => ["deleteUser"]
      }]
    }
  end

  @tag :authenticated
  test "errors when deleting nonexistent users", %{conn: conn} do
    response = post_gql(conn, %{
      query: @query,
      variables: %{id: 0}
    })

    assert response == %{
      "data" => %{"deleteUser" => nil},
      "errors" => [%{
        "locations" => [%{"column" => 0, "line" => 2}],
        "message" => "User not found",
        "path" => ["deleteUser"]
      }]
    }
  end
end
