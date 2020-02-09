defmodule AshServerWeb.SessionResolverTest do
  use AshServerWeb.ConnCase
  import AshServer.Factory

  describe "session resolver" do
    test "user can login with correct credentials", %{conn: conn} do
      user = insert(:user)

      query = """
        mutation {
          login(
            email: #{inspect user.email},
            password: "test_password"
          ) {
            session_token
            renew_token
            user {
              id
              email
            }
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert %{
        "session_token" => session_token,
        "renew_token" => renew_token,
      } = response["data"]["login"]

      assert response["data"]["login"] == %{
        "session_token" => session_token,
        "renew_token" => renew_token,
        "user" => %{
          "id" => to_string(user.id),
          "email" => user.email,
        }
      }
    end


    test "errors with incorrect credentials", %{conn: conn} do
      query = """
        mutation {
          login(
            email: "none@nothing.com",
            password: "wrong"
          ) {
            session_token
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response == %{
        "data" => %{ "login" => nil },
        "errors" => [%{
          "locations" => [%{
            "column" => 0,
            "line" => 2}
          ],
          "message" => "invalid",
          "path" => ["login"]
        }]
      }
    end


    @tag :authenticated
    test "renew tokens effectively renew the session", %{conn: conn} do
      %{current_user: current_user,
        session_token: prev_session_token,
        renew_token: prev_renew_token} = conn.assigns

      query = """
        {
          renew {
            session_token
            renew_token
            user {
              id
              email
            }
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert %{
        "session_token" => session_token,
        "renew_token" => renew_token,
        "user" => user
      } = response["data"]["renew"]

      assert session_token != prev_session_token
      assert renew_token != prev_renew_token
      assert user == %{
        "id" => to_string(current_user.id),
        "email" => current_user.email,
      }
    end
  end
end
