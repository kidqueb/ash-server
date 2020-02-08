defmodule AshServerWeb.Plug.SetCurrentUser do
  import Plug.Conn

  alias AshServerWeb.Authentication

  @session_token_cookie Application.get_env(:ash_server, :session_cookie_name)

  def init(_params) do
  end

  def call(conn, _params) do
    conn = fetch_cookies(conn)

    with session_token <- conn.req_cookies[@session_token_cookie],
    {:ok, user} <- Authentication.validate_session_token(session_token) do
      conn |> assign(:current_user, user)
    else
      _ -> conn
    end
  end
end
