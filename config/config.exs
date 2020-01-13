# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ash_tpl,
  namespace: AshTpl,
  ecto_repos: [AshTpl.Repo]

# Configures the endpoint
config :ash_tpl, AshTplWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UTZpjBUUS80oIqUf0sNwECRFMuiQtUabqS5wRdZBYCo43sZXV4bg3tOCbyX8DjId",
  render_errors: [view: AshTplWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: AshTpl.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Authorization with Pow
config :ash_tpl, :pow,
  user: AshTpl.Accounts.User,
  repo: AshTpl.Repo,
  extensions: [PowPersistentSession]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
