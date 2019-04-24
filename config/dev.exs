use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :ash, AshWeb.Endpoint,
  http: [port: 4000],
  https: [
    port: 4001,
    cipher_suite: :strong,
    certfile: "priv/cert/selfsigned.pem",
    keyfile: "priv/cert/selfsigned_key.pem"
  ],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Email dispatch
config :ash, Ash.Mailer,
  adapter: Bamboo.LocalAdapter

# Guardian key
config :ash, Ash.Guardian,
  secret_key: "M1pKbbFJX0Qsez5vMl8bzKeQOdbvQigRZcHz1IYIKrmhC9zSsWO0uNi8ACmzpsar"

# Test watcher
config :mix_test_watch,
  clear: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Configure your database
config :ash, Ash.Repo,
  username: "postgres",
  password: "postgres",
  database: "ash_dev",
  hostname: "localhost",
  pool_size: 10
