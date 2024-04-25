defmodule EcoServiceWeb.EcoServiceLive.CommunityDetails do
  use EcoServiceWeb, :live_view

  alias EcoService.EcoServiceContext
  alias ExAws.S3

  def mount(params, _session, socket) do
    pag_params = %{limit: 5, offset: 0}

    waste_details = EcoServiceContext.get_waste_by_community_id(params["id"], pag_params)
    community_detail = EcoServiceContext.get_community_by_id(params["id"])
    count_of_all_records = Enum.count(EcoServiceContext.get_waste_by_community_id(params["id"]))

    # graph

    last_one_month_waste_details =
      EcoServiceContext.get_last_one_month_waste()
      |> Enum.map(fn waste_detail ->
        if waste_detail.community_id == params["id"], do: waste_detail
      end)
      |> Enum.reject(fn waste -> waste == nil end)

    waste_bags = [
      EcoServiceContext.total_glass_bags(last_one_month_waste_details),
      EcoServiceContext.total_mixed_bags(last_one_month_waste_details),
      EcoServiceContext.total_paper_bags(last_one_month_waste_details),
      EcoServiceContext.total_plastic_bags(last_one_month_waste_details),
      EcoServiceContext.total_sanitory_bags(last_one_month_waste_details),
      EcoServiceContext.total_seg_lf_bags(last_one_month_waste_details)
    ]

    # End of graph code
    {:ok,
     socket
     |> assign(:waste_details, waste_details)
     |> assign(:community_id, params["id"])
     |> assign(:community_detail, community_detail)
     |> assign(:offset, pag_params.offset)
     |> assign(:limit, pag_params.limit)
     |> assign(:count_of_all_records, count_of_all_records)
     |> assign(:community_waste_bags, Jason.encode!(waste_bags))
     |> assign(:uploaded_files, [])
     |> allow_upload(:gate_photo_file_name,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 1,
       auto_upload: false
     )}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("image-upload", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :gate_photo_file_name, fn %{path: path}, entry ->
        key = "#{entry.uuid}#{Path.extname(entry.client_name)}"

        original_size =
          Mogrify.open(path) |> Mogrify.resize_to_limit("600x600") |> Mogrify.save(path: path)

        S3.put_object("ecoservice", key, File.read!(original_size.path))
        |> ExAws.request!()

        "/" <> key
      end)
      |> Enum.reverse()

    image_url = Enum.at(uploaded_files, 0)

    {:ok, community_detail} =
      EcoServiceContext.add_gate_photo_file_name(socket.assigns.community_detail, image_url)

    {:noreply, assign(socket, :community_detail, community_detail)}
  end

  def handle_event("remove-photo", _params, socket) do
    S3.delete_object("ecoservice", socket.assigns.community_detail.gate_photo_file_name)
    |> ExAws.request!()

    {:ok, community_detail} =
      EcoServiceContext.remove_community_gate_photo(socket.assigns.community_detail)

    {:noreply, assign(socket, :community_detail, community_detail)}
  end

  def handle_event("open-maps", params, socket) do
    community_name = params["community-name"]
    lat = params["lat"]
    long = params["long"]

    url =
      "https://www.google.com/maps/search/?api=1&query=#{lat},#{long}&destination=#{community_name}"

    {:noreply,
     socket
     |> redirect(external: url)}
  end

  def handle_event("prev", _params, socket) do
    pag_params = %{limit: socket.assigns.limit, offset: socket.assigns.offset - 5}

    waste_details =
      EcoServiceContext.get_waste_by_community_id(socket.assigns.community_id, pag_params)

    count_of_all_records =
      Enum.count(EcoServiceContext.get_waste_by_community_id(socket.assigns.community_id))

    {:noreply,
     socket
     |> assign(:waste_details, waste_details)
     |> assign(:offset, pag_params.offset)
     |> assign(:limit, pag_params.limit)
     |> assign(:count_of_all_records, count_of_all_records)}
  end

  def handle_event("next", _params, socket) do
    pag_params = %{limit: socket.assigns.limit, offset: socket.assigns.offset + 5}

    waste_details =
      EcoServiceContext.get_waste_by_community_id(socket.assigns.community_id, pag_params)

    count_of_all_records =
      Enum.count(EcoServiceContext.get_waste_by_community_id(socket.assigns.community_id))

    {:noreply,
     socket
     |> assign(:waste_details, waste_details)
     |> assign(:offset, pag_params.offset)
     |> assign(:limit, pag_params.limit)
     |> assign(:count_of_all_records, count_of_all_records)}
  end

  def handle_event("first", _params, socket) do
    pag_params = %{limit: socket.assigns.limit, offset: 0}

    waste_details =
      EcoServiceContext.get_waste_by_community_id(socket.assigns.community_id, pag_params)

    {:noreply,
     socket
     |> assign(:waste_details, waste_details)
     |> assign(:offset, pag_params.offset)}
  end

  def handle_event("last", _params, socket) do
    count_of_all_records =
      Enum.count(EcoServiceContext.get_waste_by_community_id(socket.assigns.community_id))

    offset = count_of_all_records - socket.assigns.limit
    pag_params = %{limit: socket.assigns.limit, offset: offset}

    waste_details =
      EcoServiceContext.get_waste_by_community_id(socket.assigns.community_id, pag_params)

    {:noreply,
     socket
     |> assign(:waste_details, waste_details)
     |> assign(:offset, pag_params.offset)
     |> assign(:count_of_all_records, count_of_all_records)}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(socket, :community_details, _params) do
    socket
    |> assign(:page_title, "Communtiy Details")
  end

  def apply_action(socket, :add_waste, params) do
    socket
    |> assign(:community_id, params["id"])
    |> assign(:page_title, "Add Waste")
  end

  defp error_to_string(:too_large), do: "Too large"

  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
