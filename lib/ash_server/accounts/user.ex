defmodule AshServer.Accounts.User do
  use Ecto.Schema
  import Ecto.Query, warn: false
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:password_hash, :string)
    field(:password, :string, virtual: true)
    field(:confirm_password, :string, virtual: true)
    field(:current_password, :string, virtual: true)

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:password, :confirm_password, :current_password])
    |> validate_required([:current_password])
    |> validate_current_password()
    |> validate_length(:password, min: 5, max: 255)
    |> validate_confirm_password()
    |> put_password_hash()
  end

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :confirm_password])
    |> validate_required([:email, :password, :confirm_password])
    |> unique_constraint(:email, downcase: true)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:email,  min: 5, max: 255)
    |> validate_length(:password, min: 5, max: 255)
    |> validate_confirm_password()
    |> put_password_hash()
  end

  defp validate_confirm_password(%{changes: changes} = changeset) do
    password = changes[:password]
    case changes[:confirm_password] do
      ^password -> changeset
      _ -> add_error(changeset, :confirm_password, "must match password")
    end
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end
  defp put_password_hash(changeset), do: changeset

  defp validate_current_password(%Ecto.Changeset{valid?: true, changes: %{email: email, current_password: current_password}} = changeset) do
    case AshServerWeb.Authentication.validate_password(email, current_password) do
      {:ok, _user} -> changeset
      _ -> add_error(changeset, :current_password, "is invalid")
    end
  end
  defp validate_current_password(changeset), do: changeset

  def filter_with(query, filter) do
    Enum.reduce(filter, query, fn
      {:email, email}, query ->
        from(q in query, where: ilike(q.email, ^"%#{email}%"))

      {:username, username}, query ->
        from(q in query, where: ilike(q.username, ^"%#{username}%"))
    end)
  end
end
