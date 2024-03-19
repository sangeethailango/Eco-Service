defmodule EcoServiceWeb.EcoServiceLive.Dashboard do
  use EcoServiceWeb, :live_view

  alias EcoService.EcoServiceContext

  def mount(_params, _session, socket) do
    last_one_month_waste = EcoServiceContext.get_last_one_month_waste()

    total_glass_bags = EcoServiceContext.total_glass_bags(last_one_month_waste)
    total_mixed_bags = EcoServiceContext.total_mixed_bags(last_one_month_waste)
    total_paper_bags = EcoServiceContext.total_paper_bags(last_one_month_waste)
    total_plastic_bags = EcoServiceContext.total_plastic_bags(last_one_month_waste)
    total_santiriy_bags = EcoServiceContext.total_sanitory_bags(last_one_month_waste)
    total_seg_lf_bags = EcoServiceContext.total_seg_lf_bags(last_one_month_waste)

    top_5_community_details = EcoServiceContext.top5_comm_details()

    highest_waste_collected =
    top_5_community_details
    |> Enum.map(fn waste -> waste.waste end )

    top_5_community_produce_waste =
    top_5_community_details
    |> Enum.map(fn params -> EcoServiceContext.get_community_by_id(params.community_id).name end )

    {:ok,
    socket
    |> assign(:waste_bags_of_all_communities, Jason.encode!([total_glass_bags, total_mixed_bags, total_paper_bags, total_plastic_bags, total_santiriy_bags, total_seg_lf_bags]))
    |> assign(:highest_waste_collected, Jason.encode!(highest_waste_collected))
    |> assign(:top_5_community_produce_waste, Jason.encode!(top_5_community_produce_waste))

  }
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

end
