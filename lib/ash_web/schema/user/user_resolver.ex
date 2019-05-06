defmodule AshWeb.UserResolver do
  alias Ash.{Accounts, Guardian}
  alias AshWeb.ErrorHelper

  def all(_args, _info) do
    {:ok, Accounts.list_users()}
  end

  def find(%{id: id}, _info) do
    try do
      user = Accounts.get_user!(id)
      {:ok, user}
    rescue
      e -> {:error, Exception.message(e)}
    end
  end

  def create(args, _info) do
    case Accounts.create_user(args) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> ErrorHelper.format_errors(changeset)
    end
  end

  def update(%{id: id, user: user_params}, _info) do
    Accounts.get_user!(id)
    |> Accounts.update_user(user_params)
  end

  def delete(%{id: id}, _info) do
    try do
      Accounts.get_user!(id)
      |> Accounts.delete_user
    rescue
      e -> {:error, Exception.message(e)}
    end
  end

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
