defmodule App.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()
    field(:username, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    pow_changeset(user, attrs)
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end
end
