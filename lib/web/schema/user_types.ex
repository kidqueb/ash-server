defmodule AppWeb.Schema.UserTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: App.Repo

  # """
  # Auth
  # """
  object :login_success do
    field :token, :string
    field :user, non_null(:user), resolve: assoc(:user)
  end

  # """
  # User
  # """
  object :user do
    field :id, :id
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :published_at, :naive_datetime
  end

  input_object :update_user_params do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
  end

  object :user_queries do
    field :user, non_null(:user) do
      arg :id, non_null(:id)
      resolve &AppWeb.UserResolver.find/2
    end

    field :users, list_of(:user) do
      resolve &AppWeb.UserResolver.all/2
    end
  end

  object :user_mutations do
    field :attempt_login, :success_response do
      arg :email, non_null(:string)
      resolve &AppWeb.UserResolver.attempt_login/2
    end

    field :login, :login_success do
      arg :token, non_null(:string)
      resolve &AppWeb.UserResolver.login/2
    end

    field :create_user, :success_response do
      arg :email, :string
      arg :first_name, :string
      arg :last_name, :string

      resolve &AppWeb.UserResolver.create/2
    end

    field :update_user, :user do
      arg :id, non_null(:id)
      arg :user, :update_user_params

      resolve &AppWeb.UserResolver.update/2
    end

    field :delete_user, :success_response do
      arg :id, non_null(:id)

      resolve &AppWeb.UserResolver.delete/2
    end
  end
end
