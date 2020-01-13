use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ash_tpl, AshTplWeb.Endpoint,
  http: [port: 4002],
  server: false

# Email dispatch
config :ash_tpl, AshTpl.Mailer,
  adapter: Bamboo.TestAdapter

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ash_tpl, AshTpl.Repo,
  username: "postgres",
  password: "postgres",
  database: "ash_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
