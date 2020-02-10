defmodule AshServerWeb.Schema.Queries.ListUsersTest do
  use AshServerWeb.ConnCase
  import AshServer.Factory

  @query """
    query ListUsers($filter: UserFilter, $orderBy: UserOrderBy) {
      users(filter: $filter, orderBy: $orderBy) {
        id
        email
      }
    }
  """

  test "lists all users", %{conn: conn} do
    [a, b] = insert_list(2, :user)
    response = post_gql(conn, %{
      query: @query
    })

    assert response == %{
      "data" => %{
        "users" => [
          %{"id" => to_string(a.id), "email" => a.email},
          %{"id" => to_string(b.id), "email" => b.email},
        ]
      }
    }
  end
end
