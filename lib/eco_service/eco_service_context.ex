defmodule EcoService.EcoServiceContext do

  import Ecto.Query
  alias EcoService.EcoService.Waste
  alias EcoService.Repo
  alias EcoService.EcoService.Community
  alias EcoService.EcoService.Schedule

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

  def fetch_all_community_names() do
    fetch_all_communities()
    |> Enum.map(fn community -> community.name end)
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

  def top5_comm_details() do

    all_wastes = get_all_waste()

    # calculate the sum of all wastes that is produced by a community
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

    # Sorting the communities by waste count and taking the top 5
    sum_of_all_waste_with_community_id
    |> Enum.sort_by(&(&1.waste), :desc)
    |> Enum.take(5)

  end

  # Schedules

  def get_all_schedules() do
    Schedule
    |> Repo.all()
    |> Repo.preload(:communities)
  end

  def get_schedule_by_id(schedule_id) do
    Schedule
    |> where(id: ^schedule_id)
    |> Repo.all()
    |> Repo.preload(:communities)
  end

  def monday_schedules() do
    get_all_schedules()
    |> Enum.map(fn schedule -> if schedule.day_of_week == "Monday", do: schedule end)
    |> Enum.reject(fn schedule-> schedule == nil end)
  end

  def tuesday_schedules() do
    get_all_schedules()
    |> Enum.map(fn schedule -> if schedule.day_of_week == "Tuesday", do: schedule end)
    |> Enum.reject(fn schedule-> schedule == nil end)
  end

  def wednesday_schedules() do
    get_all_schedules()
    |> Enum.map(fn schedule -> if schedule.day_of_week == "Wednesday", do: schedule end)
    |> Enum.reject(fn schedule-> schedule == nil end)
  end

  def thursday_schedules() do
    get_all_schedules()
    |> Enum.map(fn schedule -> if schedule.day_of_week == "Thursday", do: schedule end)
    |> Enum.reject(fn schedule-> schedule == nil end)
  end

  def friday_schedules() do
    get_all_schedules()
    |> Enum.map(fn schedule -> if schedule.day_of_week == "Friday", do: schedule end)
    |> Enum.reject(fn schedule-> schedule == nil end)
  end

  def saturday_schedules() do
    get_all_schedules()
    |> Enum.map(fn schedule -> if schedule.day_of_week == "Saturday", do: schedule end)
    |> Enum.reject(fn schedule-> schedule == nil end)
  end

  def add_schedule_id_to_community(%Community{} = community, params) do
    params = %{"schedule_id" =>  params}
    community
     |> Community.update_community_changeset(params)
     |> Repo.update()
   end
end
