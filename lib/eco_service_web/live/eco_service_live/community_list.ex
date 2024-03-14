defmodule EcoServiceWeb.EcoServiceLive.CommunityList do
  use EcoServiceWeb, :live_view

  alias EcoService.EcoServiceContext
  def mount(_params, _session, socket) do
    communities = EcoServiceContext.fetch_all_communities()
    {:ok,
    socket
    |> assign(:communities, communities)
    }
  end
end
