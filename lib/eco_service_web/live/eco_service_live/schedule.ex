defmodule EcoServiceWeb.EcoServiceLive.Schedule do
  use EcoServiceWeb, :live_view

  alias EcoService.EcoServiceContext
  def mount(params, _session, socket) do
    if params["schedule_id"] == "nil"   do
    {:ok,
    socket
    |> assign(:schedules_for_a_date, nil)
    |> assign(:date, nil)
    |> assign(:string_date, nil)
    }
    else
      schedules_for_a_date =
      EcoServiceContext.get_schedule_by_id(params["schedule_id"])

      date = Enum.map(schedules_for_a_date, fn schedule -> schedule.date end)
      |> List.first()
      |> Date.to_iso8601()

    {:ok,
      socket
      |> assign(:schedules_for_a_date, schedules_for_a_date)
      |> assign(:date, date)
      |> assign(:string_date, nil)
    }

    end
  end

  def handle_event("date-change", params, socket) do
     schedules_for_a_date = EcoServiceContext.get_schedules_for_date(params["date"])

     date = EcoServiceContext.format_string_date(params["date"])

     string_date = EcoServiceContext.convert_string_date_to_calender_iso_date(params["date"])


     if schedules_for_a_date ==  [] do
        {:noreply,
        socket
        |> assign(:schedules_for_a_date, nil)
        }
    else
      {:noreply,
      socket
      |> assign(:schedules_for_a_date, schedules_for_a_date)
      |> assign(:date, date)
      |> assign(:string_date, string_date)
      }
    end
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
