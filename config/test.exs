use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :app, AppWeb.Endpoint,
  http: [port: 4002],
  server: false

# Email dispatch
config :app, App.Mailer,
  adapter: Bamboo.TestAdapter

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :app, App.Repo,
  username: "postgres",
  password: "postgres",
  database: "phoeniqs_graphql_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
