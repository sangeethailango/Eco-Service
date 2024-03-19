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
end
