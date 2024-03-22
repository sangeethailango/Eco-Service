defmodule EcoServiceWeb.EcoServiceLive.EditWasteComponent do
  use EcoServiceWeb, :live_component

  alias EcoService.EcoServiceContext
  def render(assigns) do
    ~H"""
      <div>
        <%= for schedule <- @schedules do %>
            <p> <%= schedule.name %></p>
        <% end %>
      </div>
    """
  end

  def update(assigns, socket) do
    schedules =
    EcoServiceContext.get_schedule_by_id(assigns.schedule_id)
    |> Enum.map(fn schedule -> schedule.communities end)

    {:ok,
    socket
    |> assign(:schedules, List.first(schedules))
    }
  end
end
