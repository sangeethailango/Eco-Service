defmodule EcoService.EcoServiceContext do

  import Ecto.Query
  alias EcoService.Repo
  alias EcoService.EcoService.Community

  def fetch_all_communities(params) do
    Community
    |> limit(^params.limit)
    |> offset(^params.offset)
    |> Repo.all()
  end

  def fetch_all_communities() do
    Community
    |> Repo.all()
  end
end
