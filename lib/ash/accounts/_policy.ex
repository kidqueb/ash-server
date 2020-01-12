defmodule App.Accounts.Policy do
  @moduledoc """
  Set of checks to determine if an Accounts action can be executed by a user.

    @param {atom} action - the function being called in the module
    @param {struct} user - the user (typically current_user) to authorize
    @param {struct} resource - the thing we're authorizing against
  """
  @behaviour Bodyguard.Policy
  alias App.Accounts.User

  # """
  # User
  # """

  @doc "Anyone can create a user"
  def authorize(:create_user, _user, _resource), do: true

  @doc "Only a user can update their account"
  def authorize(:update_user, %User{} = current_user, %User{} = user),
    do: current_user.id == user.id

  @doc "Only a user can delete their account"
  def authorize(:delete_user, %User{} = current_user, %User{} = user),
    do: current_user.id == user.id

  # """
  # Accounts Context
  # """

  # Deny everything else
  def authorize(_action, _user, _resource), do: false
end
