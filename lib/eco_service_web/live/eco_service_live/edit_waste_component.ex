defmodule EcoServiceWeb.EcoServiceLive.EditWasteComponent do
  use EcoServiceWeb, :live_component

  alias EcoService.EcoServiceContext
  def render(assigns) do
    ~H"""
      <div>
          <h1 class="text-center font-bold text-2xl">Edit Schedule</h1>
          <p class="inline-block pt-4 text-xl "><%= @day %></p>

          <.table id="community" rows={@communities}>
             <:col :let={community} label="Communty Name"> <%= community.name %></:col>

             <:col :let={community} label="" >
                <.link phx-target={@myself} phx-click="remove_community" phx-value-id={community.id}>
                  <Heroicons.trash class="w-6 h-6" />
                </.link>
             </:col>
          </.table>

          <div class="pt-6">
             <.button phx-target={@myself} phx-click="add-community">Add Community</.button>
          </div>
          <%= if @add_community == true do %>
            <.simple_form :let={form} for={%{}} phx-target={@myself} phx-submit="save_community">
              <.input
                field={form[:community_id]}
                label="Select community"
                type="select"
                options={@options}
              />
              <.button>Save</.button>
            </.simple_form>
          <% end %>
      </div>
    """
  end

  def update(assigns, socket) do
    schedules = EcoServiceContext.get_schedule_by_id(assigns.schedule_id)

    communities = Enum.map(schedules, fn schedule -> schedule.communities end)

    day = Enum.map(schedules, fn schedule -> schedule.day_of_week end)

    {:ok,
    socket
    |> assign(:communities, List.first(communities))
    |> assign(:day, List.first(day))
    |> assign(:add_community, false)
    |> assign(assigns)
    }
  end

  def handle_event("add-community", _params, socket) do
    options =
    EcoServiceContext.fetch_all_communities()
    |> Enum.map(fn community -> {"#{community.name}", community.id} end)

    {:noreply,
    socket
    |> assign(:add_community, true)
    |> assign(:options, options)
    }
  end

  def handle_event("save_community", params, socket) do
    community = EcoServiceContext.get_community_by_id(params["community_id"])
    update_schedule = EcoServiceContext.update_schedule_id_in_community(community, socket.assigns.schedule_id)

    case update_schedule do
    {:ok, _} ->

      {:noreply,
      socket
      |> push_redirect(to: ~p"/schedules")
      |> put_flash(:info, "Successfully Added Community")
      }
    {:error, _} ->
      {:noreply,
      socket
      |> push_redirect(to: ~p"/schedules")
      |> put_flash(:error, "Couldn't Update Community")
     }
    end
  end

  def handle_event("remove_community", params, socket) do
    IO.inspect(socket.assigns.communities, label: "Commnities")
    community = EcoServiceContext.get_community_by_id(params["id"])

    update_schedule = EcoServiceContext.update_schedule_id_in_community(community,  "")

    case update_schedule do
      {:ok, _} ->

        {:noreply,
        socket
        |> assign(:communities, update_schedule)
        }
      {:error, _} ->
        {:noreply,
        socket
        |> push_redirect(to: ~p"/schedules")
        |> put_flash(:error, "Couldn't Update Community")
       }
      end
  end
end
