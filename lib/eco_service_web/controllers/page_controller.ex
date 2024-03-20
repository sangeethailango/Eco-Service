defmodule EcoServiceWeb.PageController do
  use EcoServiceWeb, :controller

  alias EcoService.EcoServiceContext

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def get_all_communities(conn, _params)do
    all_communities = EcoServiceContext.fetch_all_communities()

    all_communities = Enum.map(all_communities, fn community -> %{community_id: community.id, community_name: community.name, community_location: community.location_area_zone} end)

    json(conn, all_communities )
  end

  def add_waste(conn, params) do

    date_string = String.slice(params["date"], 3, 10)
    date = Date.from_iso8601!(date_string)

    params =  Map.replace(params, "date", date)

    insert_waste = EcoServiceContext.insert_waste(params) |> IO.inspect(label: "Insert Waste")

    case insert_waste do

      {:ok, _} ->
      conn
      |> put_status(:created)
      |> text("Data Inserted Successfully")

      {:error, _} ->
      conn
      |> put_status(:internal_server_error)
      |> text("Insertion Failed")
    end
  end
end
