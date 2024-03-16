defmodule EcoService.EcoServiceContext do

  import Ecto.Query
  alias EcoService.EcoService.Waste
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

  def delete_waste(community_id) do
    Waste
    |> where(community_id: ^community_id)
    |> Repo.delete_all()
  end

  def delete_community(id) do
    Community
    |> where(id: ^id)
    |> Repo.delete_all()
  end

  def get_community_by_id(id) do
    Community
    |> Repo.get_by(id: id)
  end

  def update_community(%Community{} = community, params) do
    community
    |> Community.changeset(params)
    |> Repo.update()
  end

  def get_waste_by_community_id(community_id) do
    Waste
    |> Repo.get_by(community_id: community_id)
    |> Repo.preload(:community)
  end
end
