defmodule EcoServiceWeb.EcoServiceLive.CommunityDetails do
  use EcoServiceWeb, :live_view

  alias EcoService.EcoServiceContext

  def mount(params, _session, socket) do
    IO.inspect(params["id"], label: "Params")
    waste_details = EcoServiceContext.get_waste_by_community_id(params["id"])

    {:ok,
    socket
    |> assign(:waste_details, [waste_details])
    }
  end
end
