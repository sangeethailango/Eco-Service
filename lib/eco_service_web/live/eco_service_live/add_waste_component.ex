defmodule EcoServiceWeb.EcoServiceLive.AddWasteComponent do
  use EcoServiceWeb, :live_component

  alias EcoService.EcoServiceContext
  def render(assigns) do
    ~H"""
      <div>
      <h1 class="text-center font-bold text-2xl">Add Community</h1>

        <.simple_form :let={form} for={%{}} phx-target={@myself} phx-submit="save">
          <.input field={form[:date]} label="Date" type="date"/>
          <.input field={form[:kg_of_glass]} label="KG of Glass"/>
          <.input field={form[:kg_of_mixed]} label="KG of Mixed"/>
          <.input field={form[:kg_of_paper]} label="KG of Paper"/>
          <.input field={form[:kg_of_plastic]} label="KG of Plastic"/>
          <.input field={form[:kg_of_sanitory]} label="KG of Sanitory"/>
          <.input field={form[:kg_of_seg_lf]} label="KG of Seg LF"/>
          <.input field={form[:mixed_bags]} label="No. of Mixed Bags"/>
          <.input field={form[:paper_bags]} label="No. of Paper Bags"/>
          <.input field={form[:plastic_bags]} label="No. of Plastic Bags"/>
          <.input field={form[:sanitory_bags]} label="No. of Sanitory Bags"/>
          <.input field={form[:seg_lf_bags]} label="No. of Seg LF bags"/>
          <.input field={form[:glass_bags]} label="No. of Glass Bags"/>
          <.input field={form[:comments]} label="Comments"/>

          <.button>Save</.button>
        </.simple_form>
      </div>
    """
  end

  def update(assigns, socket) do
    {:ok,
    socket
    |> assign(assigns)
   }
  end

  def handle_event("save", params, socket) do
    community_params = Map.put(params, "community_id", socket.assigns.community_id)
    insert_waste =  EcoServiceContext.insert_waste(community_params)

    case insert_waste do
    {:ok, _} ->
        {:noreply,
          socket
          |> put_flash(:info, "Successfully inserted")
          |> redirect(to: ~p"/communities/#{socket.assigns.community_id}/community_details")
        }
    {:error, _} ->
        {:noreply,
        socket
        |> put_flash(:error, "Cannot Insert")
        |> redirect(to: ~p"/communities/#{socket.assigns.community_id}/community_details")
        }
    end
  end
end
