defmodule EcoServiceWeb.WasteCostLive.Index do
  use EcoServiceWeb, :live_view

  alias EcoService.Total
  alias EcoService.Total.WasteCost

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :wastecosts, Total.list_wastecosts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Waste cost")
    |> assign(:waste_cost, %WasteCost{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Wastecosts")
    |> assign(:waste_cost, nil)
  end

  @impl true
  def handle_info({EcoServiceWeb.WasteCostLive.FormComponent, {:saved, waste_cost}}, socket) do
    {:noreply, stream_insert(socket, :wastecosts, waste_cost)}
  end
end
