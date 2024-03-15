defmodule EcoServiceWeb.EcoServiceLive.CommunityList do
  use EcoServiceWeb, :live_view

  alias EcoService.EcoServiceContext

  def mount(_params, _session, socket) do
    params = %{limit: 10, offset: 0}
    all_communities = EcoServiceContext.fetch_all_communities(params)
    {:ok,
    socket
    |> assign(:communities, all_communities)
    |> assign(:limit, params.limit)
    |> assign(:offset, params.offset)
    |> assign(:all_records, Enum.count(EcoServiceContext.fetch_all_communities()))
    }
  end

  def handle_event("prev", _params, socket) do
    params= %{limit: 10,  offset: socket.assigns.offset-10}
    all_communities = EcoServiceContext.fetch_all_communities(params)
    {:noreply,
    socket
    |> assign(:communities, all_communities)
    |> assign(:limit, params.limit)
    |> assign(:offset, params.offset)
    |> assign(:all_records, nil)
    |> assign(:all_records, Enum.count(EcoServiceContext.fetch_all_communities()))
   }
  end

  def handle_event("next", _params, socket) do
    params= %{limit: 10,  offset: socket.assigns.offset+10}
    all_communities = EcoServiceContext.fetch_all_communities(params)

    {:noreply,
    socket
    |> assign(:communities, all_communities)
    |> assign(:limit, params.limit)
    |> assign(:offset, params.offset)
    |> assign(:all_records, Enum.count(EcoServiceContext.fetch_all_communities()))
   }
  end
end
