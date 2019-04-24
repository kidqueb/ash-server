# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ash,
  namespace: Ash,
  ecto_repos: [Ash.Repo]

# Configures the endpoint
config :ash, AshWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8T5iuEzxfHDVecy3CnarEBWVOKZpJ3nNTydbtLorZVFlAwMgrpjRxt5URNWTaxHc",
  render_errors: [view: AshWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Ash.PubSub, adapter: Phoenix.PubSub.PG2]

# JWT
config :ash, Ash.Guardian,
  issuer: "api"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
