# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sport_hub,
  ecto_repos: [SportHub.Repo]

# Configures the endpoint
config :sport_hub, SportHubWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Cel+hJTqQ5hVAlFuf5f5bFGOuM61Xnu+sz4EEZL24E8X5CXuMlnWCJQMBpdP3uuy",
  render_errors: [view: SportHubWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: SportHub.PubSub,
  live_view: [signing_salt: "WFSBYmuM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
