defmodule AshWeb.Schema.UserTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Ash.Repo

  # """
  # Auth
  # """
  object :login_response do
    field :token, :string
    field :user, non_null(:user), resolve: assoc(:user)
  end

  # """
  # User
  # """
  object :user do
    field :id, :id
    field :email, :string
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :published_at, :naive_datetime
  end

  input_object :update_user_params do
    field :email, :string
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string
  end

  object :user_queries do
    field :user, non_null(:user) do
      arg :id, non_null(:id)
      resolve &AshWeb.UserResolver.find/2
    end

    field :users, list_of(:user) do
      resolve &AshWeb.UserResolver.all/2
    end
  end

  object :user_mutations do
    field :email_login, :success_response do
      arg :email, non_null(:string)
      resolve &AshWeb.UserResolver.email_login/2
    end

    field :login, :login_response do
      arg :token, :string
      arg :email, :string
      arg :password, :string
      resolve &AshWeb.UserResolver.login/2
    end

    field :create_user, :user do
      arg :email, :string
      arg :username, :string
      arg :first_name, :string
      arg :last_name, :string
      arg :password, :string

      resolve &AshWeb.UserResolver.create/2
    end

    field :update_user, :user do
      arg :id, non_null(:id)
      arg :user, :update_user_params

      resolve &AshWeb.UserResolver.update/2
    end

    field :delete_user, :user do
      arg :id, non_null(:id)

      resolve &AshWeb.UserResolver.delete/2
    end
  end
end
