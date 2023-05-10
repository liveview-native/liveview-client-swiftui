import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :lvn_tutorial, LvnTutorialWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "54uBXLgKApT40mU+KRpd/idj79DGR2uuRbfqFHU2haAyXZhOXA109rC6eDDIwwYN",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
