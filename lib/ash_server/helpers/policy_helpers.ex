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
end
