defmodule AppWeb.UserResolver do
  alias App.{Accounts, Guardian}
  alias AppWeb.ErrorHelper

  def all(_args, _info) do
    {:ok, Accounts.list_users()}
  end

  def find(%{id: id}, _info) do
    case Accounts.get_user(id) do
      nil -> {:error, "User id #{id} not found."}
      user -> {:ok, user}
    end
  end

  def create(args, _info) do
    case Accounts.create_user(args) do
      {:ok, _user} -> {:ok, %{success: true}}
      {:error, changeset} -> ErrorHelper.format_errors(changeset)
    end
  end

  def update(%{id: id, user: user_params}, _info) do
    Accounts.get_user!(id)
    |> Accounts.update_user(user_params)
  end

  def delete(%{id: id}, _info) do
    case Accounts.delete_user(id) do
      {:ok, _user} -> {:ok, %{success: true}}
      {:error, changeset} -> ErrorHelper.format_errors(changeset)
    end
  end

  def attempt_login(%{email: email}, _info) do
    Accounts.provide_token(email)
    {:ok, %{success: true}}
  end

  def login(%{token: token}, _info) do
    case Accounts.verify_token_value(token) do
      {:ok, user} ->
        with {:ok, jwt, _claims} <- Guardian.encode_and_sign(user) do
          {:ok, %{token: jwt, user: user}}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end
end
