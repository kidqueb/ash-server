defmodule AshServerWeb.Plug.SetCurrentUser do
  import Plug.Conn

  alias AshServerWeb.Authentication

  @session_token_cookie Application.get_env(:ash_server, :session_cookie_name)
  @renew_token_cookie Application.get_env(:ash_server, :renew_cookie_name)

  def init(_params) do
  end

  def call(conn, _params) do
    conn = fetch_cookies(conn)

    with session_token <- conn.req_cookies[@session_token_cookie],
    {:ok, user} <- Authentication.validate_session_token(session_token) do
      conn
      |> assign(:current_user, user)
      |> assign(:session_token, conn.req_cookies[@session_token_cookie])
      |> assign(:renew_token, conn.req_cookies[@renew_token_cookie])
    else
      _ -> conn
    end
  end
end
