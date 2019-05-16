defmodule Ash.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ash.Accounts.AuthToken

  schema "users" do
    field(:email, :string)
    field(:username, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    has_many(:auth_tokens, AuthToken)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :first_name, :last_name, :password])
    |> validate_required([:email, :first_name, :last_name])
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset),
    do: put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
  defp put_password_hash(changeset), do: changeset
end
