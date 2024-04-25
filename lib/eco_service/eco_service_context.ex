defmodule EcoService.EcoServiceContext do
  import Ecto.Query
  alias EcoService.EcoService.Waste
  alias EcoService.Repo
  alias EcoService.EcoService.Community
  alias EcoService.EcoService.Schedule

  @link_expires_in 60 * 10

  def fetch_all_communities(params) do
    Community
    |> limit(^params.limit)
    |> offset(^params.offset)
    |> order_by(asc: :name)
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

  def insert_community(params) do
    %Community{}
    |> Community.changeset(params)
    |> Repo.insert()
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
    last_month = Date.utc_today() |> Date.add(-30)

    query =
      from w in Waste,
        where: w.date >= ^last_month

    query
    |> Repo.all()
    |> Repo.preload(:community)
  end

  def total_glass_bags(wastes) do
    Enum.map(wastes, fn waste -> waste.glass_bags end)
    |> Enum.reject(fn bag -> is_nil(bag) end)
    |> Enum.reduce(0, &Decimal.add(&1, &2))
  end

  def total_mixed_bags(wastes) do
    Enum.map(wastes, fn waste -> waste.mixed_bags end)
    |> Enum.reject(fn bag -> bag == nil end)
    |> Enum.reduce(0, &Decimal.add(&1, &2))
  end

  def total_paper_bags(wastes) do
    Enum.map(wastes, fn waste -> waste.paper_bags end)
    |> Enum.reject(fn bag -> bag == nil end)
    |> Enum.reduce(0, &Decimal.add(&1, &2))
  end

  def total_plastic_bags(wastes) do
    Enum.map(wastes, fn waste -> waste.plastic_bags end)
    |> Enum.reject(fn bag -> bag == nil end)
    |> Enum.reduce(0, &Decimal.add(&1, &2))
  end

  def total_sanitory_bags(wastes) do
    Enum.map(wastes, fn waste -> waste.sanitory_bags end)
    |> Enum.reject(fn bag -> bag == nil end)
    |> Enum.reduce(0, &Decimal.add(&1, &2))
  end

  def total_seg_lf_bags(wastes) do
    Enum.map(wastes, fn waste -> waste.seg_lf_bags end)
    |> Enum.reject(fn bag -> bag == nil end)
    |> Enum.reduce(0, &Decimal.add(&1, &2))
  end

  def top5_comm_details() do
    all_wastes = get_all_waste()
    # calculate the sum of all wastes that is produced by a community
    sum_of_all_waste_with_community_id =
      Enum.map(all_wastes, fn waste ->
        %{
          community_id: waste.community.id,
          wastes:
            [
              waste.glass_bags,
              waste.mixed_bags,
              waste.paper_bags,
              waste.plastic_bags,
              waste.sanitory_bags,
              waste.seg_lf_bags
            ]
            |> Enum.reject(fn waste -> waste == nil end)
            |> Enum.reduce(0, &Decimal.add(&1, &2))
        }
      end)

    # Sorting the communities by waste count and taking the top 5
    sum_of_all_waste_with_community_id
    |> Enum.sort_by(& &1.wastes, :desc)
    |> Enum.take(5)
  end

  def top_5_community_and_waste() do
    top_5_community_details = top5_comm_details()

    group_by_community =
      Enum.group_by(top_5_community_details, fn detail -> detail.community_id end)

    Enum.map(
      group_by_community,
      fn {key, values} ->
        %{
          community_id: key,
          waste:
            Enum.map(values, fn value -> value.wastes end)
            |> Enum.reduce(0, &Decimal.add(&1, &2))
        }
      end
    )
  end

  # Schedules

  def get_schedules_for_date(date) do
    query =
      from d in Schedule,
        where: d.date == ^date

    query
      |> Repo.all()
      |> Repo.preload(:communities)

  end

  def get_schedule_by_id(schedule_id) do
    Schedule
    |> where(id: ^schedule_id)
    |> Repo.all()
    |> Repo.preload(:communities)
  end

  def update_schedule_id_in_community(%Community{} = community, params) do
    params = %{"schedule_id" => params}

    community
    |> Community.update_community_changeset(params)
    |> Repo.update()
  end

  #  Date formation: From dd-mm-yy to yy-mm-dd and adding 20 before year(for example adding 20 before year 16, 17.).
  def convert_to_ecto_date(date) do
    [dd, mm, yyyy] = String.split(date, "/")
    #  Adding 20 for a year.
    date = "#{dd}-#{mm}-20#{yyyy}"
    [dd, mm, yyyy] = String.split(date, "-")
    # converting from "dd-mm-yyyy" into ~D[yyyy-mm-dd] format
    Date.from_iso8601!("#{yyyy}-#{mm}-#{dd}")
  end

  # Input: "2024-03-29"
  # Output: "29-03-3024"
  def format_string_date(string_date) do
    [yyyy, mm, dd] = String.split(string_date, "-")
    "#{dd}-#{mm}-#{yyyy}"
  end

  def convert_string_date_to_ecto_date(string_date) do
    Date.from_iso8601!(string_date)
  end

  def convert_string_date_to_calender_iso_date(date) do
    Calendar.strftime(convert_string_date_to_ecto_date(date), "%a, %B %d %Y")
  end

  def format_date(date) do
    string_date = Date.to_string(date)
    [yyyy, mm, dd] = String.split(string_date, "-")
    "#{dd}-#{mm}-#{yyyy}"
  end

  def convert_to_integer(string) do
    if string != "", do: String.to_integer(string), else: nil
  end

  def search_communities(params) do
    query =
      from(p in Community,
        where: ilike(p.name, ^"#{params["name"]}%"),
        order_by: fragment("lower(name)")
      )

    Repo.all(query)
  end

  def insert_schedule(params) do
    %Schedule{}
    |> Schedule.changeset(params)
    |> Repo.insert!()
  end

  def get_signed_url(image_url) do
    config = ExAws.Config.new(:s3, Application.get_all_env(:ex_aws))
    s3_key = image_url
    s3_bucket = "ecoservice"

    {:ok, url} =
      ExAws.S3.presigned_url(config, :get, s3_bucket, s3_key, expires_in: @link_expires_in)

    url
  end

  def add_gate_photo_file_name(community_detail, image_url) do
    community_detail
    |> Ecto.Changeset.change(gate_photo_file_name: image_url)
    |> Repo.update()
  end

  def remove_community_gate_photo(community_detail) do
    community_detail
    |> Ecto.Changeset.change(gate_photo_file_name: nil)
    |> Repo.update()
  end
end
