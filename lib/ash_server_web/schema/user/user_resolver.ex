defmodule AshServerWeb.Schema.UserResolver do
  alias AshServer.Accounts
  alias AshServerWeb.ErrorHelper

  def all(args, _info) do
    {:ok, Accounts.list_users(args)}
  end

  def find(%{id: id}, _info) do
    try do
      user = Accounts.get_user!(id)
      {:ok, user}
    rescue
      error -> {:error, Exception.message(error)}
    end
  end

  def find(args, _info) do
    try do
      case Accounts.get_user_by(args) do
        nil -> {:error, "Can't find a user with given parameters."}
        user -> {:ok, user}
      end
    rescue
      error -> {:error, Exception.message(error)}
    end
  end

  def create(args, _info) do
    case Accounts.create_user(args) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> ErrorHelper.format_errors(changeset)
    end
  end

  def update(%{id: id, user: user_params}, %{context: %{current_user: current_user}}) do
    try do
      user = Accounts.get_user!(id)

      with :ok <- Accounts.permit(:update_user, current_user, user) do
        Accounts.update_user(user, user_params)
      end
    rescue
      error -> {:error, Exception.message(error)}
    end
  end

  def update(_args, _info) do
    {:error, :unauthorized}
  end

  def delete(%{id: id}, %{context: %{current_user: current_user}}) do
    try do
      user = Accounts.get_user!(id)

      with :ok <- Accounts.permit(:delete_user, current_user, user) do
        Accounts.delete_user(user)
      end
    rescue
      error -> {:error, Exception.message(error)}
    end
  end

  def delete(_args, _info) do
    {:error, :unauthorized}
  end
end
