defmodule AshWeb.Schema.PostTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Ash.Repo


  object :post do
    field :id, :id 
    field :body, :string
    field :is_active, :boolean
  end

  input_object :update_post_params do 
    field :body, :string
    field :is_active, :boolean 
  end

  object :post_queries do
    field :post, non_null(:post) do
      arg :id, non_null(:id)
      resolve &AshWeb.PostResolver.find/2
    end

    field :posts, list_of(:post) do
      resolve &AshWeb.PostResolver.all/2
    end
  end

  object :post_mutations do
    field :create_post, :post do 
      arg :body, :string
      arg :is_active, :boolean
      resolve &AshWeb.PostResolver.create/2
    end

    field :update_post, :post do
      arg :id, non_null(:id)
      arg :post, :update_post_params

      resolve &AshWeb.PostResolver.update/2
    end

    field :delete_post, :post do
      arg :id, non_null(:id)

      resolve &AshWeb.PostResolver.delete/2
    end
  end
end
