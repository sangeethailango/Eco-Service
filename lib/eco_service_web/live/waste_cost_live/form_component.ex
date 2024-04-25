defmodule EcoServiceWeb.WasteCostLive.FormComponent do
  use EcoServiceWeb, :live_component

  alias EcoService.Total

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage waste_cost records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="waste_cost-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:cost_of_mix_waste]} type="number" label="Cost of mix waste" step="any" />
        <.input field={@form[:cost_of_paper_waste]} type="number" label="Cost of paper waste" step="any" />
        <.input field={@form[:cost_of_plastic_waste]} type="number" label="Cost of plastic waste" step="any" />
        <.input field={@form[:cost_of_sanitory_waste]} type="number" label="Cost of sanitory waste" step="any" />
        <.input field={@form[:cost_of_seg_lf_waste]} type="number" label="Cost of seg lf waste" step="any" />
        <.input field={@form[:cost_of_glass_waste]} type="number" label="Cost of glass waste" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Waste cost</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{waste_cost: waste_cost} = assigns, socket) do
    changeset = Total.change_waste_cost(waste_cost)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"waste_cost" => waste_cost_params}, socket) do
    changeset =
      socket.assigns.waste_cost
      |> Total.change_waste_cost(waste_cost_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"waste_cost" => waste_cost_params}, socket) do
    save_waste_cost(socket, socket.assigns.action, waste_cost_params)
  end

  defp save_waste_cost(socket, :new, waste_cost_params) do
    case Total.create_waste_cost(waste_cost_params) do
      {:ok, waste_cost} ->
        notify_parent({:saved, waste_cost})

        {:noreply,
         socket
         |> put_flash(:info, "Waste cost created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
