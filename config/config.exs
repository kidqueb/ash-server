# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ash_server,
  namespace: AshServer,
  ecto_repos: [AshServer.Repo],
  session_cookie_name: "session_token",
  renew_cookie_name: "renew_token",
  session_ttl: 1000 * 60 * 15,           # 15 minutes in milliseconds
  renew_ttl: 1000 * 60 * 60 * 24 * 7   # 7 days in milliseconds

# Configures the endpoint
config :ash_server, AshServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UTZpjBUUS80oIqUf0sNwECRFMuiQtUabqS5wRdZBYCo43sZXV4bg3tOCbyX8DjId",
  render_errors: [view: AshServerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: AshServer.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
