defmodule EcoService.Repo do
  use Ecto.Repo,
    otp_app: :eco_service,
    adapter: Ecto.Adapters.Postgres
end
