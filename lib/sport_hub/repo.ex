defmodule SportHub.Repo do
  use Ecto.Repo,
    otp_app: :sport_hub,
    adapter: Ecto.Adapters.Postgres
end
