defmodule EcoServiceWeb.EcoServiceLive.CommunityList do
  use EcoServiceWeb, :live_view

  alias EcoService.EcoServiceContext

  def mount(_params, _session, socket) do
    pag_params = %{limit: 10, offset: 0}
    all_communities = EcoServiceContext.fetch_all_communities(pag_params)

    {:ok,
    socket
    |> assign(:communities, all_communities)
    |> assign(:limit, pag_params.limit)
    |> assign(:offset, pag_params.offset)
    |> assign(:count_of_all_records, Enum.count(EcoServiceContext.fetch_all_communities()))
    }
  end

  def handle_event("prev", _params, socket) do
    pag_params= %{limit: 10,  offset: socket.assigns.offset-10}
    all_communities = EcoServiceContext.fetch_all_communities(pag_params)

    {:noreply,
    socket
    |> assign(:communities, all_communities)
    |> assign(:limit, pag_params.limit)
    |> assign(:offset, pag_params.offset)
    |> assign(:count_of_all_records, Enum.count(EcoServiceContext.fetch_all_communities()))
   }
  end

  def handle_event("next", _params, socket) do
    pag_params= %{limit: 10,  offset: socket.assigns.offset+10}
    all_communities = EcoServiceContext.fetch_all_communities(pag_params)

    {:noreply,
    socket
    |> assign(:communities, all_communities)
    |> assign(:limit, pag_params.limit)
    |> assign(:offset, pag_params.offset)
    |> assign(:count_of_all_records, Enum.count(EcoServiceContext.fetch_all_communities()))
   }
  end

  def handle_event("first", _params, socket) do
    pag_params = %{limit: 10, offset: 0}
    all_communities = EcoServiceContext.fetch_all_communities(pag_params)

    {:noreply,
    socket
    |> assign(:communities, all_communities)
    |> assign(:offset, pag_params.offset)
   }
  end

  def handle_event("last", _params, socket) do
    all_communities_count = Enum.count(EcoServiceContext.fetch_all_communities())

    offset = all_communities_count - socket.assigns.limit

    pag_params = %{limit: 10, offset: offset}

    all_communities = EcoServiceContext.fetch_all_communities(pag_params)

    {:noreply,
    socket
    |> assign(:communities, all_communities)
    |> assign(:offset, pag_params.offset)
    |> assign(:count_of_all_records, all_communities_count)
   }
  end


  def handle_event("delete", params, socket) do
    EcoServiceContext.delete_waste(params["id"])
    EcoServiceContext.delete_community(params["id"])

    {:noreply,
    socket
    |> put_flash(:info, "Community Deleted Successfully")
    |> redirect(to: ~p"/communities")
   }
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "List of Community")
  end

  def apply_action(socket, :edit, params) do
    socket
    |> assign(:page_title, "Edit Community")
    |> assign(:community_id, params["id"])
  end
end
