defmodule AshWeb.PostResolverTest do
  use AshWeb.ConnCase
  import Ash.PostFactory

  describe "post resolver" do
    test "lists all posts", %{conn: conn} do
      posts = insert_list(3, :post)

      query = """
        {
          posts {
            id
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["posts"] == to_id_array(posts)
    end

    test "finds a post by id", %{conn: conn} do
      post = insert(:post)

      query = """
        {
          post(id: #{post.id}) {
            id
            body
            is_active
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["post"] == %{
        "id" => to_string(post.id),
        "body" => post.body,
        "is_active" => post.is_active,
      }
    end

  test "errors when looking for a nonexistent post by id", %{conn: conn} do
      query = """
        {
          post(id: "doesnt exist") {
            id
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"] == nil
      assert response["errors"]
    end

    test "creates a new post", %{conn: conn} do
      post_params = params_for(:post, %{
        body: "some body",
        is_active: true,
      })

      query = """
        mutation {
          createPost(
            body: #{inspect post_params.body},
            is_active: #{inspect post_params.is_active},
          ) {
            body
            is_active
          }
        }
      """

      response = post_gql(conn, %{query: query})

      assert response["data"]["createPost"] == %{
        "body" => post_params.body,
        "is_active" => post_params.is_active,
      }
    end

    test "updates a post", %{conn: conn} do
      post = insert(:post)

      query = """
        mutation UpdatePost($id: ID!, $post: UpdatePostParams!) {
          updatePost(id:$id, post:$post) {
            id
            body
            is_active
          }
        }
      """

      variables = %{
        id: post.id,
        post: %{
          body: "some updated body",
          is_active: false,
        }
      }

      response = post_gql(conn, %{query: query, variables: variables})

      assert response["data"]["updatePost"] == %{
        "id" => to_string(post.id), 
        "body" => variables.post.body,
        "is_active" => variables.post.is_active,
      }
    end
  end

  test "deletes a post", %{conn: conn} do
    post = insert(:post)

    query = """
      mutation {
        deletePost(id: #{post.id}) {
          id
        }
      }
    """

    response = post_gql(conn, %{query: query})

    assert response["data"]["deletePost"] == %{
      "id" => to_string(post.id)
    }
  end
end
