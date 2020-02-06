defmodule AshServer.Accounts.User do
  use Ecto.Schema
  import Ecto.Query, warn: false
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:password_hash, :string)
    field(:password, :string, virtual: true)

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email, downcase: true)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:email,  min: 5, max: 255)
    |> validate_length(:password, min: 5, max: 255)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end
  defp put_password_hash(changeset), do: changeset

  def filter_with(query, filter) do
    Enum.reduce(filter, query, fn
      {:email, email}, query ->
        from(q in query, where: ilike(q.email, ^"%#{email}%"))

      {:username, username}, query ->
        from(q in query, where: ilike(q.username, ^"%#{username}%"))
    end)
  end
end
