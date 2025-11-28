defmodule Sammelana.Repo do
  use Ecto.Repo,
    otp_app: :sammelana,
    adapter: Ecto.Adapters.Postgres
end
