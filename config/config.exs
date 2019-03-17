# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :risk_battle_simulator, RiskBattleSimulatorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "S9VOCKxla7bKLg4EHYaRQUv6+Foaru0WJaqoOhp5IFIIfMEXqOLr5bxmM8vOQgaA",
  render_errors: [view: RiskBattleSimulatorWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RiskBattleSimulator.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
