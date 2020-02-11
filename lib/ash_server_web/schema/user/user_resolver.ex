defmodule AshServerWeb.Schema.UserResolver do
  import AshServer.Helpers.PolicyHelpers
  alias AshServer.Accounts

  def create(%{user: user}, _info) do
    case Accounts.create_user(user) do
      {:ok, user} -> {:ok, user}
      {:error, error} -> {:error, error}
    end
  end

  def find(%{id: id}, info) do
    with {:ok, current_user} <- get_current_user(info),
    :ok <- Accounts.permit(:fetch_user, current_user, dirty_id(id)) do
      Accounts.fetch_user(id)
    else
      {:error, error} -> {:error, error}
      _ -> {:error, "Something went wrong"}
    end
  end

  def all(args, _info) do
    {:ok, Accounts.list_users(args)}
  end

  def update(%{id: id, user: user_params}, info) do
    with {:ok, current_user} <- get_current_user(info),
    :ok <- Accounts.permit(:update_user, current_user, dirty_id(id)),
    {:ok, user} = Accounts.fetch_user(id) do
      Accounts.update_user(user, user_params)
    else
      {:error, error} -> {:error, error}
      _ -> {:error, "Something went wrong"}
    end
  end

  def delete(%{id: id}, info) do
    with {:ok, current_user} <- get_current_user(info),
    :ok <- Accounts.permit(:delete_user, current_user, dirty_id(id)),
    {:ok, user} <- Accounts.fetch_user(id) do
      Accounts.delete_user(user)
    else
      {:error, error} -> {:error, error}
      _ -> {:error, "Something went wrong"}
    end
  end

  def me(_args, info), do: get_current_user(info)
end
