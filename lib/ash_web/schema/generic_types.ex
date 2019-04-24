defmodule AshWeb.Schema.GenericTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Ash.Repo

  object :success_response do
    field :success, :boolean
  end
end
