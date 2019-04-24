defmodule Ash.Accounts.AuthRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "auth_requests" do
    field(:email, :string)
    timestamps()
  end

  @doc false
  def changeset(auth_request, attrs) do
    auth_request
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end
end
