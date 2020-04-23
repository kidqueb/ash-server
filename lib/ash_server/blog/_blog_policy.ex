defmodule AshServer.Blog.Policy do
  @moduledoc """
  Authorize a user's ability to call Blog actions.

    @param {atom} action - the function being called in the module
    @param {struct} user - the user (typically current_user) to authorize
    @param {struct} resource - the resource they are trying top modify
  """
  @behaviour Bodyguard.Policy

  def authorize(:get_post, %{id: current_user_id}, %{user_id: user_id}), do:
    current_user_id == user_id

  # Catch all
  def authorize(_action, _user, _resource), do: true
end
