defmodule AshServerWeb.Schema.PostTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: App.Repo

  alias AshServerWeb.Schema.PostResolver

  @desc "A post"
  object :post do
    field :id, :id
    field :title, :string
    field :body, :string
    field :is_public, :string
  end

  @desc "Post parameters"
  input_object :post_params do
    field :title, :string
    field :body, :string
    field :is_public, :string
  end

  @desc "Post filter"
  input_object :post_filter do
    field :id, :id
    field :title, :string
    field :body, :string
    field :is_public, :string
  end

  @desc "Post ordering"
  input_object :post_order_by do
    field :id, :id
    field :title, :string
    field :body, :string
    field :is_public, :string
  end

  object :post_queries do
    @desc "A single post"
    field :post, :post do
      arg :id, non_null(:id)
      resolve &PostResolver.find/2
    end

    @desc "A list of posts"
    field :posts, list_of(:post) do
      arg :filter, :post_filter
      arg :order_by, :post_order_by
      resolve &PostResolver.all/2
    end
  end

  object :post_mutations do
    @desc "Create a post"
    field :create_post, :post do
      arg :post, :post_params

      resolve &PostResolver.create/2
    end

    @desc "Update a post"
    field :update_post, :post do
      arg :id, non_null(:id)
      arg :post, :post_params

      resolve &PostResolver.update/2
    end

    @desc "Delete a post"
    field :delete_post, :post do
      arg :id, non_null(:id)

      resolve &PostResolver.delete/2
    end
  end
end
