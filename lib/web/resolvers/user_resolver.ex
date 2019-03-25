defmodule AppWeb.UserResolver do
  alias App.{Accounts, Guardian}

  def all(_args, _info) do
    {:ok, Accounts.list_users()}
  end

  def find(%{id: id}, %{context: context}) do
    IO.inspect(context)
    case Accounts.get_user!(id) do
      nil -> {:error, "User id #{id} not found"}
      user -> {:ok, user}
    end
  end
  def find(%{id: id}, _info) do
    case Accounts.get_user!(id) do
      nil -> {:error, "User id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def create(args, _info) do
    Accounts.create_user(args)
  end

  def update(%{id: id, user: user_params}, _info) do
    Accounts.get_user!(id)
    |> Accounts.update_user(user_params)
  end

  def delete(%{id: id}, _info) do
    Accounts.delete_user(id)
  end

  def attempt_login(%{email: email}, _info) do
    Accounts.provide_token(email)
    {:ok, %{message: "Email with login link has been sent to the given email address."}}
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

  def me(_args, %{context: %{current_user: current_user}}) do
    {:ok, Accounts.get_user!(current_user.id)}
  end

  def me(_args, _info) do
    {:error, "Not authenticated."}
  end
end
