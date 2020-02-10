defmodule AshServerWeb.Schema.Mutations.LoginTest do
  use AshServerWeb.ConnCase

  @query """
    mutation Login($email: String!, $password: String!) {
      login(email: $email, password: $password) {
        session_token
        renew_token
        user {
          id
          email
        }
      }
    }
  """

  test "user can login with correct credentials", %{conn: conn} do
    user = insert(:user)
    response = post_gql(conn, %{
      query: @query,
      variables: %{email: user.email, password: "test_password"}
    })

    assert %{
      "session_token" => session_token,
      "renew_token" => renew_token,
    } = response["data"]["login"]

    assert response == %{
      "data" => %{
        "login" => %{
          "session_token" => session_token,
          "renew_token" => renew_token,
          "user" => %{
            "id" => to_string(user.id),
            "email" => user.email,
          }
        }
      }
    }
  end


  test "errors with incorrect credentials", %{conn: conn} do
    response = post_gql(conn, %{
      query: @query,
      variables: %{email: "nope@email.com", password: "wrongpw"}
    })

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
end
