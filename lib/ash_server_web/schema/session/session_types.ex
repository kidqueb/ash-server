defmodule AshServerWeb.Schema.SessionTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: AshServer.Repo

  alias AshServerWeb.Schema.SessionResolver

  object :session do
    field :session_token, :string
    field :refresh_token, :string
  end

  object :session_mutations do
    field :login, :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &SessionResolver.login/2
    end
  end
end
