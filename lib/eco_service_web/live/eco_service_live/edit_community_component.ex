defmodule EcoServiceWeb.EcoServiceLive.EditCommunityComponent do
  use EcoServiceWeb, :live_component

  alias EcoService.EcoServiceContext

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-center font-bold  text-2xl"> <%= @title %> </h1>
      <.simple_form :let={form} for={%{}} phx-target={@myself} phx-submit="update-community">
        <.input
          field={form[:name]}
          label="Community Name"
          value={if !is_nil(@community), do: @community.name}
          required/>
        <.input
          field={form[:location_area_zone]}
          label="Location Area Zone"
          value={if !is_nil(@community), do: @community.location_area_zone }
          required
        />
        <.input
          field={form[:contact_person_name]}
          label="Contact person name"
          value={if !is_nil(@community), do: @community.contact_person_name}
        />
        <.input
          field={form[:contact_person_phone_number]}
          label="Contact person phone number"
          value={if !is_nil(@community), do: @community.contact_person_phone_number}
        />
        <.input
          field={form[:contact_person_email]}
          label="Contact person email"
          value={if !is_nil(@community), do: @community.contact_person_email}
        />
        <.input
          field={form[:fs_acc_num]}
          label="FS ACC number"
          value={if !is_nil(@community), do: @community.fs_acc_num}
        />
        <.button>Save</.button>
      </.simple_form>
    </div>
    """
  end

  def update(assigns, socket) do
    community =
      if assigns.community_id == "" do
         nil
      else
        EcoServiceContext.get_community_by_id(assigns.community_id)
      end

    {:ok,
     socket
     |> assign(:community, community)
     |> assign(:title, assigns.title)
    }
  end

  def handle_event("update-community", params, socket) do
    community =
      if !is_nil(socket.assigns.community) do
        EcoServiceContext.update_community(socket.assigns.community, params)
      else
        EcoServiceContext.insert_community(params)
      end

    case community do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Successfully Update")
         |> redirect(to: ~p"/communities")}
      {:error, _} ->
        {:noreply,
          socket
          |> put_flash(:error, "Cannot insert")
          |> redirect(to: ~p"/communities")}

    end
  end
end
