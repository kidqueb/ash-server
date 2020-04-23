defmodule AshServer.BlogTest do
  use AshServer.DataCase
  import AshServer.Factory

  alias AshServer.Blog

  describe "posts" do
    alias AshServer.Blog.Post
    @invalid_attrs %{body: nil, is_public: nil, title: nil}

    test "list_posts/1 returns all posts" do
      posts = insert_list(3, :post)
      assert Blog.list_posts() == posts
    end

    test "get_post!/1 returns the post with given id" do
      post = insert(:post)
      assert Blog.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      post_params = params_for(:post)

      assert {:ok, %Post{} = post} = Blog.create_post(post_params)
      assert post.body == post_params.body
      assert post.is_public == post_params.is_public
      assert post.title == post_params.title
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = insert(:post)
      post_params = params_for(:post, %{body: "some updated body", is_public: "some updated is_public", title: "some updated title"})

      assert {:ok, %Post{} = post} = Blog.update_post(post, post_params)
      assert post.body == post_params.body
      assert post.is_public == post_params.is_public
      assert post.title == post_params.title
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = insert(:post)
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert post == Blog.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = insert(:post)
      assert {:ok, %Post{}} = Blog.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = insert(:post)
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end
  end
end
