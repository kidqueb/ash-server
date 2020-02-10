defmodule AshServerWeb.Schema.Mutations.CreateUserTest do
  use AshServerWeb.ConnCase
  import AshServer.Factory

  @query """
    mutation CreateUser($user: CreateUserParams!) {
      createUser(user: $user) {
        email
      }
    }
  """

  test "creates a new user", %{conn: conn} do
    user_params =  %{
      email: "tim@tebow.com",
      password: "somepassword",
      confirm_password: "somepassword",
    }

    response = post_gql(conn, %{
      query: @query,
      variables: %{user: user_params}
    })

    assert response == %{
      "data" => %{
        "createUser" => %{
          "email" => user_params.email
        }
      }
    }
  end
end
