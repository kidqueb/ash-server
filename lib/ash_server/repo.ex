defmodule AshServer.Repo do
  use Ecto.Repo,
    otp_app: :ash_server,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query, warn: false

  def fetch(query, id) do
    query
    |> where(id: ^id)
    |> fetch
  end

  def fetch(query) do
    case all(query) do
      [] -> {:error, query}
      [obj] -> {:ok, obj}
      _ -> raise "Expected one or no items, got many items #{inspect(query)}"
    end
  end
end
