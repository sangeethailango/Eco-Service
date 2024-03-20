defmodule EcoServiceWeb.EcoServiceLive.Dashboard do
  use EcoServiceWeb, :live_view

  alias EcoService.EcoServiceContext

  def mount(_params, _session, socket) do

    # Total waste of all communities
    last_one_month_waste_details = EcoServiceContext.get_last_one_month_waste()

    waste_bags_of_all_communities =
    [
    EcoServiceContext.total_glass_bags(last_one_month_waste_details),
    EcoServiceContext.total_mixed_bags(last_one_month_waste_details),
    EcoServiceContext.total_paper_bags(last_one_month_waste_details),
    EcoServiceContext.total_plastic_bags(last_one_month_waste_details),
    EcoServiceContext.total_sanitory_bags(last_one_month_waste_details),
    EcoServiceContext.total_seg_lf_bags(last_one_month_waste_details)
    ]

    # Total waste of top 5 communiteis
    top_5_community_details = EcoServiceContext.top5_comm_details()

    highest_count_of_waste_produced_by_communities =
    top_5_community_details
    |> Enum.map(fn waste -> waste.waste end )

    top_5_community_produce_waste =
    top_5_community_details
    |> Enum.map(fn details -> EcoServiceContext.get_community_by_id(details.community_id).name end )

    # catagory wise waste of top 5 communities

    waste_details =
    top_5_community_details
    |> Enum.map(fn top_community_detail -> EcoServiceContext.get_waste_by_community_id(top_community_detail.community_id) end)

    top_communities_glass_bags =
    waste_details
    |> Enum.map(fn waste ->  EcoServiceContext.total_glass_bags(waste) end )

    top_communities_mixed_bags =
    waste_details
    |> Enum.map(fn waste ->  EcoServiceContext.total_mixed_bags(waste) end )

    top_communities_paper_bags =
    waste_details
    |> Enum.map(fn waste ->  EcoServiceContext.total_paper_bags(waste) end )

    top_communities_plastic_bags =
    waste_details
    |> Enum.map(fn waste ->  EcoServiceContext.total_plastic_bags(waste) end )

    top_communities_sanitory_bags =
    waste_details
    |> Enum.map(fn waste ->  EcoServiceContext.total_sanitory_bags(waste) end )

    top_communities_seg_lf_bags =
    waste_details
    |> Enum.map(fn waste ->  EcoServiceContext.total_seg_lf_bags(waste) end )

    {:ok,
    socket
    |> assign(:waste_bags_of_all_communities, Jason.encode!(waste_bags_of_all_communities))
    |> assign(:highest_count_of_waste_produced_by_communities, Jason.encode!(highest_count_of_waste_produced_by_communities))
    |> assign(:top_5_community_produce_waste, Jason.encode!(top_5_community_produce_waste))
    |> assign(:top_communities_glass_bags, Jason.encode!(top_communities_glass_bags))
    |> assign(:top_communities_mixed_bags, Jason.encode!(top_communities_mixed_bags))
    |> assign(:top_communities_paper_bags, Jason.encode!(top_communities_paper_bags))
    |> assign(:top_communities_plastic_bags, Jason.encode!(top_communities_plastic_bags))
    |> assign(:top_communities_sanitory_bags, Jason.encode!(top_communities_sanitory_bags))
    |> assign(:top_communities_seg_lf_bags, Jason.encode!(top_communities_seg_lf_bags))
    |> assign(:type_of_chart, "Total waste")
  }
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def handle_event("type_of_chart_change", params, socket) do

    type_of_chart = if params["type_of_chart"] == "total_waste" do
        "Total waste"
      else
        "Categories of Waste"
      end

      {:noreply,
      socket
      |> assign(:type_of_chart, type_of_chart)
      }
  end
end
