defmodule AshServerWeb.Authentication.SessionStore do
  use GenServer

  @table :session_store
  @session_ttl Application.get_env(:ash_server, :session_ttl)
  @renew_ttl Application.get_env(:ash_server, :renew_ttl)

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_session_token(token, session_payload, ttl \\ @session_ttl) do
    insert(token, session_payload, ttl)
  end

  def add_renew_token(token, session_payload, ttl \\ @renew_ttl) do
    insert(token, session_payload, ttl)
  end

  def validate_token(token) do
    case :ets.lookup(@table, token) do
      [{_token, session_payload}] ->
        add_session_token(token, session_payload)
        {:ok, session_payload}

      _ ->
        {:error, "No valid sessions"}
    end
  end

  defp insert(key, value, ttl) do
    GenServer.call(__MODULE__, {:insert, key, value, ttl})
  end

  # """
  # Server callbacks
  # """

  def init(_) do
    :ets.new(@table, [
      :set,
      :named_table,
      :public,
      read_concurrency: true,
      write_concurrency: true
    ])

    {:ok, %{invalidators: %{}}}
  end

  def handle_call({:insert, key, value, ttl}, _from, state = %{invalidators: invalidators}) do
    case Map.get(invalidators, key) do
      nil -> nil
      invalidator -> Process.cancel_timer(invalidator)
    end

    :ets.insert(@table, {key, value})
    invalidator = Process.send_after(self(), {:invalidate, key}, ttl)

    {:reply, key, %{state | invalidators: Map.put(invalidators, key, invalidator)}}
  end

  def handle_info({:invalidate, key}, state = %{invalidators: invalidators}) do
    :ets.delete(@table, key)
    {:noreply, %{state | invalidators: Map.delete(invalidators, key)}}
  end
end
