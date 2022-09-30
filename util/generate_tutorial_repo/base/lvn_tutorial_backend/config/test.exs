import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :lvn_tutorial, LvnTutorialWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "84mk/7QE6BBiqalRp9AjNc7EQSmaBUCfI+GhXGMj3aCEH4nV5W1NVTbalZF5Ee27",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
