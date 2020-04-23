defmodule AshServerWeb.Schema.DeletePostTest do
  use AshServerWeb.ConnCase
  import AshServer.Factory

  @query """
    mutation DeletePost($id: ID!) {
      deletePost(id: $id) {
        id
      }
    }
  """

  @tag :authenticated
  test "a post can be deleted", %{conn: conn} do
    post = insert(:post)
    response = post_gql(conn, %{
      query: @query,
      variables: %{id: post.id}
    })

    assert response == %{
      "data" => %{
        "deletePost" => %{
          "id" => to_string(post.id)
        }
      }
    }
  end

  @tag :authenticated
  test "errors when deleting a nonexistent post", %{conn: conn} do
    response = post_gql(conn, %{
      query: @query,
      variables: %{id: 0}
    })

    assert response == %{
      "data" => %{"deletePost" => nil},
      "errors" => [%{
        "locations" => [%{"column" => 0, "line" => 2}],
        "message" => "Post not found",
        "path" => ["deletePost"]
      }]
    }
  end
end
