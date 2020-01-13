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
  import AshServer.Factory

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

    conn = if tags[:authenticated] do
      user = insert(:user, %{
        password: "password",
        confirm_password: "password"
      })

      Pow.Plug.assign_current_user(conn, user, otp_app: :ash_server)
    else
      conn
    end

    {:ok, conn: conn}
  end
end
