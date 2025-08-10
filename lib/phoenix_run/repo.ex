defmodule PhoenixRun.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_run,
    adapter: Ecto.Adapters.Postgres
end
