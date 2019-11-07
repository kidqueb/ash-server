defmodule AshWeb.ConnCase do
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
  import Ash.Factory

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias AshWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint AshWeb.Endpoint

      import Ash.Factory
      import Ash.TestUtils
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Ash.Repo)

    conn = Phoenix.ConnTest.build_conn()

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Ash.Repo, {:shared, self()})
    end

    {conn, current_user} = if tags[:authenticated] do
      user = insert(:user)
      {:ok, token, _claims} = Ash.Guardian.encode_and_sign(user)

      conn = Plug.Conn.put_req_header(conn, "authorization", "Bearer " <> token)

      {conn, user}
    else
      {conn, nil}
    end

    {:ok, conn: conn, current_user: current_user}
  end
end
