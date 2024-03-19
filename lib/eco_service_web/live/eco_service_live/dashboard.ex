defmodule EcoServiceWeb.EcoServiceLive.Dashboard do
  use EcoServiceWeb, :live_view

  alias EcoService.EcoServiceContext

  def mount(_params, _session, socket) do
    all_waste = EcoServiceContext.get_last_one_month_waste()

    total_glass_bags = EcoServiceContext.total_glass_bags(all_waste)
    total_mixed_bags = EcoServiceContext.total_mixed_bags(all_waste)
    total_paper_bags = EcoServiceContext.total_paper_bags(all_waste)
    total_plastic_bags = EcoServiceContext.total_plastic_bags(all_waste)
    total_santiriy_bags = EcoServiceContext.total_sanitory_bags(all_waste)
    total_seg_lf_bags = EcoServiceContext.total_seg_lf_bags(all_waste)

    {:ok,
    socket
    |> assign(:number_of_bags, Jason.encode!([total_glass_bags, total_mixed_bags, total_paper_bags, total_plastic_bags, total_santiriy_bags, total_seg_lf_bags]))
    }
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

end
