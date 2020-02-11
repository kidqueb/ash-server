defmodule AshServer.Accounts.Policy do
  @moduledoc """
  Set of checks to determine if an Accounts action can be executed by a user.

    @param {atom} action - the function being called in the module
    @param {struct} user - the user (typically current_user) to authorize
    @param {any} resource - typically a thing we're authorizing against, or an ID
  """
  @behaviour Bodyguard.Policy

  # """
  # User
  # """
  alias AshServer.Accounts.User

  @doc "Anyone can create a user"
  def authorize(:create_user, _user, _resource), do: true

  @doc "Only a user can view their account"
  def authorize(:fetch_user, %User{id: current_user_id}, user_id),
    do: current_user_id == user_id

  def authorize(:get_user, %User{id: current_user_id}, user_id),
    do: current_user_id == user_id

  def authorize(:get_user_by_email!, %User{id: current_user_id}, user_id),
    do: current_user_id == user_id

  @doc "Only a user can update their account"
  def authorize(:update_user, %User{id: current_user_id}, user_id),
    do: current_user_id == user_id

  @doc "Only a user can delete their account"
  def authorize(:delete_user, %User{id: current_user_id}, user_id),
    do: current_user_id == user_id

  @doc "Only a user can create themselves a changeset"
  def authorize(:change_user, %User{id: current_user_id}, user_id),
    do: current_user_id == user_id

  # """
  # Default
  # """

  def authorize(_action, _user, _resource), do: false
end
