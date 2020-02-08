defmodule AshServerWeb.Authentication do
  @moduledoc """
  Methods for authenticating user access.
  """

  alias AshServer.Accounts
  alias AshServer.Accounts.User
  alias AshServerWeb.Authentication.SessionStore

  def validate_password(email, password) do
    case Accounts.get_user_by_email!(email) do
      %User{} = user -> Argon2.check_pass(user, password)
      error -> {:error, error}
    end
  end

  def create_tokens(session_payload) do
    session_token = Ecto.UUID.generate()
    refresh_token = Ecto.UUID.generate()

    SessionStore.add_session_token(session_token, session_payload)
    SessionStore.add_refresh_token(refresh_token, session_payload)

    [session_token, refresh_token]
  end

  def validate_session_token(token) do
    SessionStore.validate_token(token)
  end

  def validate_refresh_token(token) do
    case SessionStore.validate_token(token) do
      {:ok, session_payload} -> create_tokens(session_payload)
      {:error, error} -> {:error, error}
    end
  end
end
