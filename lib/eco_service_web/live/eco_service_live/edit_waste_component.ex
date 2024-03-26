defmodule EcoServiceWeb.EcoServiceLive.EditWasteComponent do
  use EcoServiceWeb, :live_component

  alias EcoService.EcoServiceContext
  def render(assigns) do
    ~H"""
      <div >
          <span class="font-bold">Day: </span><h1 class="inline-block pl-4"><%= @day %></h1>

          <h2 class="font-bold">List of communities</h2>
          <%= for community <- @communities do %>
              <p> <%= community.name %></p>

              <.button phx-target={@myself} phx-click="remove_community" phx-value-id={community.id}>
                  Delete Community
              </.button>
          <% end %>
          <div class="pt-4">
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
    community = EcoServiceContext.get_community_by_id(params["id"])

    update_schedule = EcoServiceContext.update_schedule_id_in_community(community,  "")

    case update_schedule do
      {:ok, _} ->

        {:noreply,
        socket
        |> push_redirect(to: ~p"/schedules")
        |> put_flash(:info, "Successfully Updated Community")
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
