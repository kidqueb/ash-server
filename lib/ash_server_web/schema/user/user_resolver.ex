defmodule AshServerWeb.Schema.UserResolver do
  alias AshServer.Accounts

  def all(args, _info) do
    {:ok, Accounts.list_users(args)}
  end

  def find(%{id: id}, _info) do
    Accounts.fetch_user(id)
  end

  def find(args, _info) do
    case Accounts.get_user_by(args) do
      nil -> {:error, "Can't find a user with given parameters."}
      user -> {:ok, user}
    end
  end

  def create(args, _info) do
    case Accounts.create_user(args) do
      {:ok, user} -> {:ok, user}
      {:error, error} -> {:error, error}
    end
  end

  def update(%{id: id, user: user_params}, info) do
    with %{current_user: current_user} = info.context,
    {:ok, user} <- Accounts.fetch_user(id) do
      case Accounts.permit(:update_user, current_user, user) do
        :ok -> Accounts.update_user(user, user_params)
        {:error, error} -> {:error, error}
      end
    end
  end

  def delete(%{id: id}, info) do
    with %{current_user: current_user} = info.context,
    {:ok, user} <- Accounts.fetch_user(id) do
      case Accounts.permit(:delete_user, current_user, user) do
        :ok -> Accounts.delete_user(user)
        {:error, error} -> {:error, error}
      end
    end
  end

  def me(_args, info) do
    case info.context do
      %{current_user: nil} -> {:error, :unauthorized}
      %{current_user: current_user} -> {:ok, current_user}
    end
  end
end
