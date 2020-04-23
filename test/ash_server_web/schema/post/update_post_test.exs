defmodule AshServerWeb.Schema.UpdatePostTest do
  use AshServerWeb.ConnCase
  import AshServer.Factory

  @query """
    mutation UpdatePost($id: ID!, $post: PostParams!) {
      updatePost(id: $id, post: $post) {
        id
        title
        body
        is_public
      }
    }
  """

  @tag :authenticated
  test "a post can be updated", %{conn: conn} do
    post = insert(:post)
    post_params = params_for(:post, %{
      title: "some updated title",
      body: "some updated body",
      is_public: "some updated is_public",
    })

    response = post_gql(conn, %{
      query: @query,
      variables: %{
        id: post.id,
        post: post_params
      }
    })

    assert response == %{
      "data" => %{
        "updatePost" => %{
          "id" => to_string(post.id),
          "title" => post_params.title,
          "body" => post_params.body,
          "is_public" => post_params.is_public,
        }
      }
    }
  end

  @tag :authenticated
  test "errors when updating nonexistent post", %{conn: conn} do
    response = post_gql(conn, %{
      query: @query,
      variables: %{id: "0", post: %{}}
    })

    assert response == %{
      "data" => %{"updatePost" => nil},
      "errors" => [
        %{
          "locations" => [%{"column" => 0, "line" => 2}],
          "message" => "Post not found",
          "path" => ["updatePost"]
        }
      ]
    }
  end
end
