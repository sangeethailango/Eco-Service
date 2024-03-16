defmodule EcoServiceWeb.EcoServiceLive.CommunityDetails do
  use EcoServiceWeb, :live_view

  alias EcoService.EcoServiceContext

  def mount(params, _session, socket) do
    waste_details = EcoServiceContext.get_waste_by_community_id(params["id"])
    community_detail = EcoServiceContext.get_community_by_id(params["id"])
    {:ok,
    socket
    |> assign(:waste_details, waste_details)
    |> assign(:community_id, params["id"])
    |> assign(:community_detail, community_detail)
    }
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end


  def apply_action(socket, :community_details, _params) do
    socket
    |> assign(:page_title, "Communtiy Details")
  end

  def apply_action(socket, :add_waste, params) do
    socket
    |> assign(:community_id, params["id"])
    |> assign(:page_title, "Add Waste")
  end
end
