defmodule AshServer.Helpers.PolicyHelpers do
  @moduledoc """
  Methods for interacting with policy and checking authorization.
  """

  alias AshServer.Accounts.User

  def get_current_user(info) do
    case info.context do
      %{current_user: %User{} = current_user} -> {:ok, current_user}
      _ -> {:error, :unauthorized}
    end
  end

  def dirty_id(id) when is_integer(id), do: id
  def dirty_id(id), do: String.to_integer(id)
end
