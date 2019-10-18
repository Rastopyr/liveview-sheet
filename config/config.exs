# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :liveview,
  namespace: SheetLive

# Configures the endpoint
config :liveview, SheetLiveWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RsKay0nQ4x5gJTjIvY4A5ClAt2EWAmMFa9SuMauZFtYj9E4TbtIPRsx/vSCaW9kp",
  render_errors: [view: SheetLiveWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SheetLive.PubSub, adapter: Phoenix.PubSub.PG2]

config :liveview, SheetLiveWeb.Endpoint,
  live_view: [
    signing_salt: "somesecret"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
