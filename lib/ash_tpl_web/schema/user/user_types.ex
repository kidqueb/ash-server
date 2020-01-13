defmodule AshTplWeb.Schema.UserTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: AshTpl.Repo

  alias AshTplWeb.Schema.UserResolver

  object :user do
    field :id, :id
    field :email, :string
    field :username, :string
  end

  input_object :update_user_params do
    field :email, :string
    field :username, :string
    field :password, :string
    field :confirm_password, :string
    field :current_password, :string
  end

  object :user_queries do
    field :user, non_null(:user) do
      arg :id, non_null(:id)
      resolve &UserResolver.find/2
    end

    field :users, list_of(:user) do
      resolve &UserResolver.all/2
    end
  end

  object :user_mutations do
    field :create_user, :user do
      arg :email, :string
      arg :username, :string
      arg :password, :string
      arg :confirm_password, :string

      resolve &UserResolver.create/2
    end

    field :update_user, :user do
      arg :id, non_null(:id)
      arg :user, :update_user_params

      resolve &UserResolver.update/2
    end

    field :delete_user, :user do
      arg :id, non_null(:id)

      resolve &UserResolver.delete/2
    end
  end
end
