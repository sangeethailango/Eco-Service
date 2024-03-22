defmodule EcoServiceWeb.EcoServiceLive.Schedule do
  use EcoServiceWeb, :live_view

  alias EcoService.EcoServiceContext
  def mount(_params, _session, socket) do

  monday_schedule = EcoServiceContext.monday_schedules()
  tuesday_schedule = EcoServiceContext.tuesday_schedules()
  wednesday_schedule = EcoServiceContext.wednesday_schedules()
  thursday_schedule = EcoServiceContext.thursday_schedules()
  friday_schedule = EcoServiceContext.friday_schedules()
  saturday_schedule = EcoServiceContext.saturday_schedules()

   {:ok,
    socket
    |> assign(:monday_schedule,  monday_schedule)
    |> assign(:tuesday_schedule, tuesday_schedule)
    |> assign(:wednesday_schedule, wednesday_schedule)
    |> assign(:thursday_schedule, thursday_schedule)
    |> assign(:friday_schedule, friday_schedule)
    |> assign(:saturday_schedule, saturday_schedule)
    }
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Schedule Details")
  end

  def apply_action(socket, :edit_schedule, params) do
    socket
    |> assign(:page_title, "Edit Schedules")
    |> assign(:schedule_id, params["schedule_id"])
  end
end
