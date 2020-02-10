defmodule AshServerWeb.UserResolverTest do
  use AshServerWeb.ConnCase
  import AshServer.Factory

  describe "user resolver" do


    @tag :authenticated
    test "users can delete themselves", %{conn: conn} do
      %{current_user: current_user} = conn.assigns

      query = """
        mutation {
          deleteUser(id: #{current_user.id}) { id }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["deleteUser"] == %{
        "id" => to_string(current_user.id)
      }
    end

    test "errors when deleting nonexistent users", %{conn: conn} do
      query = """
        mutation {
          deleteUser(id: 0) { id }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response == %{
        "data" => %{"deleteUser" => nil},
        "errors" => [%{
          "locations" => [%{"column" => 0, "line" => 2}],
          "message" => "User not found",
          "path" => ["deleteUser"]
        }]
      }
    end

    @tag :authenticated
    test "other users cannot delete a different user", %{conn: conn} do
      user = insert(:user)

      query = """
        mutation {
          deleteUser(id: #{user.id}) { id }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response == %{
        "data" => %{"deleteUser" => nil},
        "errors" => [%{
          "locations" => [%{"column" => 0, "line" => 2}],
          "message" => "unauthorized",
          "path" => ["deleteUser"]
        }]
      }
    end
  end
end
