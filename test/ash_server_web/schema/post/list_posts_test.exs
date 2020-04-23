defmodule AshServerWeb.Schema.ListPostsTest do
  use AshServerWeb.ConnCase
  import AshServer.Factory

  @query """
    query ListPosts($filter: PostFilter, $orderBy: PostOrderBy) {
      posts(filter: $filter, orderBy: $orderBy) {
        id
      }
    }
  """

  test "lists all posts", %{conn: conn} do
    [a, b] = insert_list(2, :post)
    response = post_gql(conn, %{
      query: @query
    })

    assert response == %{
      "data" => %{
        "posts" => [
          %{"id" => to_string(a.id)},
          %{"id" => to_string(b.id)},
        ]
      }
    }
  end
end
