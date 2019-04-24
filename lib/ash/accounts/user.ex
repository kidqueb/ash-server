defmodule Ash.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ash.Accounts.AuthToken

  schema "users" do
    field(:email, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    has_many(:auth_tokens, AuthToken)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name])
    |> validate_required([:email, :first_name, :last_name])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
