use Mix.Config

config :strainer, Strainer.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "stainer_test",
  username: "postgres",
  password: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :info
