defmodule Ash.Accounts.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ash.Accounts.User

  schema "auth_tokens" do
    field(:value, :string)
    belongs_to(:user, User)
    timestamps(updated_at: false)
  end

  @doc false
  def changeset(auth_token, user) do
    auth_token
    |> cast(%{}, [])
    |> put_assoc(:user, user)
    |> put_change(:value, generate_token(user))
    |> validate_required([:value, :user])
    |> unique_constraint(:value)
  end

  # """
  # Generate a random and url-encoded token of given length
  # """
  defp generate_token(nil), do: nil
  defp generate_token(user) do
    Phoenix.Token.sign(AshWeb.Endpoint, "user", user.id)
  end
end
