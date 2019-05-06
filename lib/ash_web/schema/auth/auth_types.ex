defmodule AshWeb.Schema.AuthTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Ash.Repo

  alias AshWeb.Schema.AuthResolver

  object :login_response do
    field :token, :string
    field :user, non_null(:user), resolve: assoc(:user)
  end

  object :auth_mutations do
    field :email_login, :success_response do
      arg :email, non_null(:string)
      resolve &AuthResolver.email_login/2
    end

    field :login, :login_response do
      arg :token, :string
      arg :email, :string
      arg :password, :string
      resolve &AuthResolver.login/2
    end
  end
end
