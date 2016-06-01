use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :app_phoenix, AppPhoenix.Endpoint,
  http: [port: 4001],
  #server: false
  server: true

config :app_phoenix, :sql_sandbox, true

# Print only warnings and errors during test
config :logger, level: :warn

# Password digest hash, bcrypt_log_rounds - security config, 4 for test is good
config :comeonin, bcrypt_log_rounds: 4

# Configure your database
config :app_phoenix, AppPhoenix.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "",
  database: "app_phoenix_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
