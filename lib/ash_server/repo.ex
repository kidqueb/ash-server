defmodule AshServer.Repo do
  use Ecto.Repo,
    otp_app: :ash_server,
    adapter: Ecto.Adapters.Postgres
end
