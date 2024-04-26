defmodule EcoServiceWeb.EcoServiceLive.EditCommunityComponent do
  use EcoServiceWeb, :live_component

  alias EcoService.EcoServiceContext

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-center font-bold  text-2xl">Edit Community</h1>
      <.simple_form :let={form} for={%{}} phx-target={@myself} phx-submit="update-community">
        <.input field={form[:name]} label="Community Name " value={@community.name} required/>
        <.input
          field={form[:location_area_zone]}
          label="Location"
          value={@community.location_area_zone}
          required
        />
        <.input
          field={form[:contact_person_name]}
          label="Contact person name"
          value={@community.contact_person_name}
        />
        <.input
          field={form[:contact_person_phone_number]}
          label="Contact person phone number"
          value={@community.contact_person_phone_number}
        />
        <.input
          field={form[:contact_person_email]}
          label="Contact person email"
          value={@community.contact_person_email}
        />
        <.input
          field={form[:fs_acc_num]}
          label="FS ACC number"
          value={@community.fs_acc_num}
        />
        <.button>Save</.button>
      </.simple_form>
    </div>
    """
  end

  def update(assigns, socket) do
    community = EcoServiceContext.get_community_by_id(assigns.community_id)

    {:ok,
     socket
     |> assign(:community, community)}
  end

  def handle_event("update-community", params, socket) do
    community = EcoServiceContext.update_community(socket.assigns.community, params)

    case community do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Successfully Update")
         |> redirect(to: ~p"/communities")}
    end
  end
end
