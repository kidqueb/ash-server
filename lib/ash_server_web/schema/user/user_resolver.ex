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

  def update(%{id: id, user: user_params}, info) do
    %{current_user: current_user} = info.context

    try do
      user = Accounts.get_user!(id)

      case Accounts.permit(:update_user, current_user, user) do
        :ok -> Accounts.update_user(user, user_params)
        error -> error
      end
    rescue
      error -> {:error, Exception.message(error)}
    end
  end

  def delete(%{id: id}, info) do
    %{current_user: current_user} = info.context

    try do
      user = Accounts.get_user!(id)

      case Accounts.permit(:delete_user, current_user, user) do
        :ok -> Accounts.delete_user(user)
      end
    rescue
      error -> {:error, Exception.message(error)}
    end
  end
end
