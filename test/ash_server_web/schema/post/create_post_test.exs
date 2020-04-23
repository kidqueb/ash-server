defmodule AshServerWeb.Schema.CreatePostTest do
  use AshServerWeb.ConnCase
  import AshServer.Factory

  @query """
    mutation CreatePost($post: PostParams!) {
      createPost(post: $post) {
        title
        body
        is_public
      }
    }
  """

  test "creates a new post", %{conn: conn} do
    post_params = params_for(:post)

    response = post_gql(conn, %{
      query: @query,
      variables: %{post: post_params}
    })

    assert response == %{
      "data" => %{
        "createPost" => %{
          "title" => post_params.title,
          "body" => post_params.body,
          "is_public" => post_params.is_public,
        }
      }
    }
  end
end
