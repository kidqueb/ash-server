defmodule AshServer.Accounts.User do
  use Ecto.Schema
  import Ecto.Query, warn: false
  import Ecto.Changeset
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()
    field(:username, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> pow_changeset(attrs)
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end

  def filter_with(query, filter) do
    Enum.reduce(filter, query, fn
      {:email, email}, query ->
        from q in query, where: ilike(q.email, ^"%#{email}%")
      {:username, username}, query ->
        from q in query, where: ilike(q.username, ^"%#{username}%")
    end)
  end
end
