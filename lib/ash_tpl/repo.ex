defmodule AshTpl.Repo do
  use Ecto.Repo,
    otp_app: :ash_tpl,
    adapter: Ecto.Adapters.Postgres
end
