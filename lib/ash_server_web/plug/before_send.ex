defmodule AshServerWeb.Plug.BeforeSend do
  alias Plug.Conn

  @session_cookie_name Application.get_env(:ash_server, :session_cookie_name)
  @renew_cookie_name Application.get_env(:ash_server, :renew_cookie_name)
  @session_ttl Application.get_env(:ash_server, :session_ttl)
  @renew_ttl Application.get_env(:ash_server, :renew_ttl)

  def handle_response(conn, %Absinthe.Blueprint{result: %{data: data}}) do
    case data do
      %{"login" => %{"sessionToken" => session_token, "renewToken" => renew_token}} ->
        conn
        |> Conn.put_resp_cookie(@session_cookie_name, session_token, secure: true, httpOnly: true, max_age: @session_ttl)
        |> Conn.put_resp_cookie(@renew_cookie_name, renew_token, secure: true, httpOnly: true, max_age: @renew_ttl)

      _ ->
        conn
    end
  end

  def handle_response(conn, _), do: conn
end
