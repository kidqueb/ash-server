defmodule AshServerWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate
  alias Plug.Conn
  import AshServer.Factory

  @session_cookie_name Application.get_env(:ash_server, :session_cookie_name)
  @renew_cookie_name Application.get_env(:ash_server, :renew_cookie_name)

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias AshServerWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint AshServerWeb.Endpoint

      import AshServer.Factory
      import AshServer.TestUtils
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(AshServer.Repo)

    conn = Phoenix.ConnTest.build_conn()

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(AshServer.Repo, {:shared, self()})
    end

    {conn, current_user} = if tags[:authenticated] do
      current_user = insert(:user)
      {session_token, renew_token} = AshServerWeb.Authentication.create_tokens(current_user)

      conn = conn
      |> Phoenix.ConnTest.put_req_cookie(@session_cookie_name, session_token)
      |> Phoenix.ConnTest.put_req_cookie(@renew_cookie_name, renew_token)
      |> Conn.fetch_cookies()
      |> Conn.assign(:current_user, current_user)
      |> Conn.assign(:session_token, session_token)
      |> Conn.assign(:renew_token, renew_token)

      {conn, current_user}
    else
      {conn, nil}
    end

    conn = Conn.fetch_cookies(conn)

    {:ok, conn: conn, current_user: current_user}
  end
end
