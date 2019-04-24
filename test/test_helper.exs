{:ok, _} = Ashlication.ensure_all_started(:ex_machina)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Ash.Repo, :manual)
