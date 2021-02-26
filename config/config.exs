# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config



# Configures the endpoint
config :eltix, EltixWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DuDCjbMC61aFB5VGZwMTLxFo33R8/BJ/eckEA0q8V8noa4Z5D/7EIPT4bqrjZK2O",
  render_errors: [view: EltixWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Eltix.PubSub,
  live_view: [signing_salt: "T4oA+NbXX/KJc3joGxp/vR94MKFQzk50"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
