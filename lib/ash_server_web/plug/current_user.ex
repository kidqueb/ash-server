defmodule AshServerWeb.Plug.SetCurrentUser do
  import Plug.Conn

  alias AshServerWeb.Authentication

  @session_token_cookie :session_token

  def init(_params) do
  end

  def call(conn, _params) do
    with session_token <- conn.req_cookies[@session_token_cookie],
    {:ok, user} <- Authentication.validate_session_token(session_token) do
      conn |> assign(@session_token_cookie, user)
    else
      _ -> conn
    end
  end
end
