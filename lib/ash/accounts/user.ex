defmodule App.Accounts.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    pow_changeset(user, attrs)
  end
end
