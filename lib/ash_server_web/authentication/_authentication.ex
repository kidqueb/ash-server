defmodule AshServerWeb.Authentication do
  @moduledoc """
  Methods for authenticating user access.
  """


  alias AshServer.Accounts
  alias AshServer.Accounts.User
  alias AshServerWeb.Endpoint

  @session_salt "ash_server_session_token_salt"
  @refresh_salt "ash_server_refresh_token_salt"
  @session_expiration 60 * 15             # 15 minutes
  @refresh_expiration 60 * 60 * 24 * 14   # 7 days

  def validate_password(email, password) do
    case Accounts.get_user_by_email!(email) do
      {:ok, user} -> Argon2.check_pass(user, password)
      {:error, error} -> {:error, error}
    end
  end

  def create_tokens(%User{id: id}) do
    session_token = Phoenix.Token.sign(Endpoint, @session_salt, id)
    refresh_token = Phoenix.Token.sign(Endpoint, @refresh_salt, id)
    [session_token, refresh_token]
  end

  def validate_session_token(token) do
    Phoenix.Token.verify(Endpoint, @session_salt, token, max_age: @session_expiration)
  end

  def validate_refresh_token(token) do
    Phoenix.Token.verify(Endpoint, @refresh_salt, token, max_age: @refresh_expiration)
  end
end
