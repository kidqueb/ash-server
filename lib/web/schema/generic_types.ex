defmodule AppWeb.Schema.GenericTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: App.Repo

  object :success_response do
    field :success, :boolean
  end
end
