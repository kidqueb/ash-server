defmodule AshWeb.Schema.AuthResolver do
  alias Ash.{Accounts, Guardian}

  def email_login(%{email: email}, _info) do
    Accounts.provide_token(email)
    {:ok, %{success: true}}
  end

  def login(%{token: token}, _info) do
    case Accounts.verify_token_value(token) do
      {:ok, user} -> encode_and_sign(user)
      {:error, reason} -> {:error, reason}
    end
  end

  def login(%{email: email, password: password}, _info) do
    case Accounts.authenticate_password(email, password) do
      {:ok, user} -> encode_and_sign(user)
      {:error, reason} -> {:error, reason}
    end
  end

  def login(_attrs, _info) do
    {:error, "Incorrect email or password"}
  end

  defp encode_and_sign(user) do
    with {:ok, jwt, _claims} <- Guardian.encode_and_sign(user) do
      {:ok, %{token: jwt, user: user}}
    end
  end
end
