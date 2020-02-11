defmodule AshServerWeb.Schema.RenewSessionTest do
  use AshServerWeb.ConnCase

  @query """
    {
      renewSession {
        session_token
        renew_token
        user {
          id
          email
        }
      }
    }
  """

  @tag :authenticated
  test "effectively renews the session", %{conn: conn} do
    %{current_user: current_user,
      session_token: prev_session_token,
      renew_token: prev_renew_token} = conn.assigns

    response = post_gql(conn, %{query: @query})

    assert %{
      "session_token" => session_token,
      "renew_token" => renew_token,
      "user" => user
    } = response["data"]["renewSession"]

    assert session_token != prev_session_token
    assert renew_token != prev_renew_token
    assert user == %{
      "id" => to_string(current_user.id),
      "email" => current_user.email,
    }
  end
end
