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

  def get_waste_by_community_id(community_id, params) do
    query =
      from w in Waste,
      where: w.community_id == ^community_id,
      limit: ^params.limit,
      offset: ^params.offset

    query
    |> Repo.all()
    |> Repo.preload(:community)
  end

  def get_waste_by_community_id(community_id) do
    Waste
    |> where(community_id: ^community_id)
    |> Repo.all()
  end

  def insert_waste(params) do
    %Waste{}
    |> Waste.add_waste_changeset(params)
    |> Repo.insert()
  end

  def get_all_waste() do
    Waste
    |> Repo.all()
    |> Repo.preload(:community)
  end

  def get_last_one_month_waste() do
    last_month = Date.utc_today |> Date.add(-30)
    query =
      from w in Waste,
      where: w.date >= ^last_month

    query
    |> Repo.all()
    |> Repo.preload(:community)
  end

  def total_glass_bags(wastes) do
    glass_bags = Enum.map(wastes, fn waste -> waste.glass_bags end)
    Enum.sum(Enum.reject(glass_bags, fn bag -> bag == nil end))
  end

  def total_mixed_bags(wastes) do
    mixed_bags = Enum.map(wastes, fn waste -> waste.mixed_bags end)
    Enum.sum(Enum.reject(mixed_bags, fn bag -> bag == nil end))
  end
  def total_paper_bags(wastes) do
    paper_bags = Enum.map(wastes, fn waste -> waste.paper_bags end)
    Enum.sum(Enum.reject(paper_bags, fn bag -> bag == nil end))
  end
  def total_plastic_bags(wastes) do
    plastic_bags = Enum.map(wastes, fn waste -> waste.plastic_bags end)
    Enum.sum(Enum.reject(plastic_bags, fn bag -> bag == nil end))
  end
  def total_sanitory_bags(wastes) do
    sanitory_bags = Enum.map(wastes, fn waste -> waste.sanitory_bags end)
    Enum.sum(Enum.reject(sanitory_bags, fn bag -> bag == nil end))
  end
  def total_seg_lf_bags(wastes) do
    seg_lf_bags = Enum.map(wastes, fn waste -> waste.seg_lf_bags end)
    Enum.sum(Enum.reject(seg_lf_bags, fn bag -> bag == nil end))
  end

  def top_5_communities_produce_waste() do

    all_wastes = get_all_waste()

    sum_of_all_waste_with_community_id =

    Enum.map(all_wastes, fn waste ->
      %{
        community_id: waste.community.id,
        waste:
              [waste.glass_bags, waste.mixed_bags, waste.paper_bags, waste.plastic_bags, waste.sanitory_bags, waste.seg_lf_bags]
              |> Enum.reject( fn waste -> waste == nil end)
              |> Enum.sum()
      }
    end)
    # IO.inspect(sum_of_all_waste_with_community_id, label: "Sum")

    sum_of_all_waste_with_community_id
    |> Enum.map(fn waste -> waste.waste end) |> IO.inspect(label: "inspect")
    |> Enum.sort(&(&1 >= &2))

    |> Enum.take(5)

  end
end
