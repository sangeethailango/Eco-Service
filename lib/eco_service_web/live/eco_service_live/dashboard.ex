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

    # ----------------------------------------------------------------------------------
    # total
    top_5_community_details = EcoServiceContext.top5_comm_details()

    highest_waste_collected =
    top_5_community_details
    |> Enum.map(fn waste -> waste.waste end )

    top_5_community_produce_waste =
    top_5_community_details
    |> Enum.map(fn details -> EcoServiceContext.get_community_by_id(details.community_id).name end )

    # -------------------------------------------------------------------------------------
    # catagory wise

    waste_details = Enum.map(top_5_community_details, fn top_community_detail -> EcoServiceContext.get_waste_by_community_id(top_community_detail.community_id) end)
    top_communities_glass_bags = Enum.map(waste_details, fn waste ->  EcoServiceContext.total_glass_bags(waste) end )
    top_communities_mixed_bags = Enum.map(waste_details, fn waste ->  EcoServiceContext.total_mixed_bags(waste) end )
    top_communities_paper_bags = Enum.map(waste_details, fn waste ->  EcoServiceContext.total_paper_bags(waste) end )
    top_communities_plastic_bags = Enum.map(waste_details, fn waste ->  EcoServiceContext.total_plastic_bags(waste) end )
    top_communities_sanitory_bags = Enum.map(waste_details, fn waste ->  EcoServiceContext.total_sanitory_bags(waste) end )
    top_communities_seg_lf_bags = Enum.map(waste_details, fn waste ->  EcoServiceContext.total_seg_lf_bags(waste) end )


    {:ok,
    socket
    |> assign(:waste_bags_of_all_communities, Jason.encode!([total_glass_bags, total_mixed_bags, total_paper_bags, total_plastic_bags, total_santiriy_bags, total_seg_lf_bags]))
    |> assign(:highest_waste_collected, Jason.encode!(highest_waste_collected))
    |> assign(:top_5_community_produce_waste, Jason.encode!(top_5_community_produce_waste))
    |> assign(:top_communities_glass_bags, Jason.encode!(top_communities_glass_bags))
    |> assign(:top_communities_mixed_bags, Jason.encode!(top_communities_mixed_bags))
    |> assign(:top_communities_paper_bags, Jason.encode!(top_communities_paper_bags))
    |> assign(:top_communities_plastic_bags, Jason.encode!(top_communities_plastic_bags))
    |> assign(:top_communities_sanitory_bags, Jason.encode!(top_communities_sanitory_bags))
    |> assign(:top_communities_seg_lf_bags, Jason.encode!(top_communities_seg_lf_bags))

  }
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

end
