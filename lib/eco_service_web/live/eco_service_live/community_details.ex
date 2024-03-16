defmodule EcoServiceWeb.EcoServiceLive.CommunityDetails do
  use EcoServiceWeb, :live_view

  alias EcoService.EcoServiceContext

  def mount(params, _session, socket) do
    pag_params = %{limit: 5, offset: 0}

    waste_details = EcoServiceContext.get_waste_by_community_id(params["id"], pag_params)
    community_detail = EcoServiceContext.get_community_by_id(params["id"])
    count_of_all_records =  Enum.count(EcoServiceContext.get_waste_by_community_id(params["id"]))

    {:ok,
    socket
    |> assign(:waste_details, waste_details)
    |> assign(:community_id, params["id"])
    |> assign(:community_detail, community_detail)
    |> assign(:offset, pag_params.offset)
    |> assign(:limit, pag_params.limit)
    |> assign(:count_of_all_records, count_of_all_records)
    }
  end

  def handle_event("prev", _params, socket) do
    pag_params = %{limit: socket.assigns.limit, offset: socket.assigns.offset-5}

    waste_details = EcoServiceContext.get_waste_by_community_id(socket.assigns.community_id, pag_params)
    count_of_all_records = Enum.count(EcoServiceContext.get_waste_by_community_id(socket.assigns.community_id))

    {:noreply,
    socket
    |> assign(:waste_details, waste_details)
    |> assign(:offset, pag_params.offset)
    |> assign(:limit, pag_params.limit)
    |> assign(:count_of_all_records, count_of_all_records)
    }
  end

  def handle_event("next", _params, socket) do
    pag_params = %{limit: socket.assigns.limit, offset: socket.assigns.offset+5}

    waste_details = EcoServiceContext.get_waste_by_community_id(socket.assigns.community_id, pag_params)
    count_of_all_records = Enum.count(EcoServiceContext.get_waste_by_community_id(socket.assigns.community_id))


    {:noreply,
    socket
    |> assign(:waste_details, waste_details)
    |> assign(:offset, pag_params.offset)
    |> assign(:limit, pag_params.limit)
    |> assign(:count_of_all_records, count_of_all_records)
    }
  end

  def handle_event("first", _params, socket) do
    pag_params = %{limit: socket.assigns.limit, offset: 0}

    waste_details = EcoServiceContext.get_waste_by_community_id(socket.assigns.community_id, pag_params)

    {:noreply,
    socket
    |> assign(:waste_details, waste_details)
    |> assign(:offset, pag_params.offset)
   }
  end

  def handle_event("last", _params, socket) do

    count_of_all_records = Enum.count(EcoServiceContext.get_waste_by_community_id(socket.assigns.community_id))

    offset = count_of_all_records - socket.assigns.limit
    pag_params = %{limit: socket.assigns.limit, offset: offset}

    waste_details = EcoServiceContext.get_waste_by_community_id(socket.assigns.community_id, pag_params)

    {:noreply,
    socket
    |> assign(:waste_details, waste_details)
    |> assign(:offset, pag_params.offset)
    |> assign(:count_of_all_records, count_of_all_records)
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
