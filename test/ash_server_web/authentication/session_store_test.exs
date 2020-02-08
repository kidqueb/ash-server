defmodule AshServerWeb.Authentication.SessionStoreTest do
  use ExUnit.Case, async: true
  alias AshServerWeb.Authentication.SessionStore

  @table :session_store
  @test_ttl 1
  def ttl_delay, do: Process.sleep(100)

  setup do
    token = Ecto.UUID.generate

    %{token: token,
      payload: %{id: token <> "-id"}}
  end

  test "creates session store on application boot" do
    assert :ets.whereis(@table) != :undefined
  end

  test "add/expire session token", %{token: token, payload: payload} do
    SessionStore.add_session_token(token, payload, @test_ttl)

    assert :ets.lookup(@table, token) == [{token, payload}]
    ttl_delay()
    assert :ets.lookup(@table, token) == []
  end

  test "add/expire refresh token", %{token: token, payload: payload} do
    SessionStore.add_refresh_token(token, payload, 1)

    assert :ets.lookup(@table, token) == [{token, payload}]
    ttl_delay()
    assert :ets.lookup(@table, token) == []
  end

  test "returns session payload when validating session", %{token: token, payload: payload} do
    SessionStore.add_session_token(token, payload)

    assert SessionStore.validate_token(token) == {:ok, payload}
  end

  test "returns error for invalid session" do
    assert {:error, _error} = SessionStore.validate_token("none")
  end
end
