defmodule EcoServiceWeb.WasteCostLiveTest do
  use EcoServiceWeb.ConnCase

  import Phoenix.LiveViewTest
  import EcoService.TotalFixtures

  @create_attrs %{cost_of_glass_waste: "120.5", cost_of_mix_waste: "120.5", cost_of_paper_waste: "120.5", cost_of_plastic_waste: "120.5", cost_of_sanitory_waste: "120.5", cost_of_seg_lf_waste: "120.5"}
  @update_attrs %{cost_of_glass_waste: "456.7", cost_of_mix_waste: "456.7", cost_of_paper_waste: "456.7", cost_of_plastic_waste: "456.7", cost_of_sanitory_waste: "456.7", cost_of_seg_lf_waste: "456.7"}
  @invalid_attrs %{cost_of_glass_waste: nil, cost_of_mix_waste: nil, cost_of_paper_waste: nil, cost_of_plastic_waste: nil, cost_of_sanitory_waste: nil, cost_of_seg_lf_waste: nil}

  defp create_waste_cost(_) do
    waste_cost = waste_cost_fixture()
    %{waste_cost: waste_cost}
  end

  describe "Index" do
    setup [:create_waste_cost]

    test "lists all wastecosts", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/wastecosts")

      assert html =~ "Listing Wastecosts"
    end

    test "saves new waste_cost", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/wastecosts")

      assert index_live |> element("a", "New Waste cost") |> render_click() =~
               "New Waste cost"

      assert_patch(index_live, ~p"/wastecosts/new")

      assert index_live
             |> form("#waste_cost-form", waste_cost: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#waste_cost-form", waste_cost: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/wastecosts")

      html = render(index_live)
      assert html =~ "Waste cost created successfully"
    end

    test "updates waste_cost in listing", %{conn: conn, waste_cost: waste_cost} do
      {:ok, index_live, _html} = live(conn, ~p"/wastecosts")

      assert index_live |> element("#wastecosts-#{waste_cost.id} a", "Edit") |> render_click() =~
               "Edit Waste cost"

      assert_patch(index_live, ~p"/wastecosts/#{waste_cost}/edit")

      assert index_live
             |> form("#waste_cost-form", waste_cost: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#waste_cost-form", waste_cost: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/wastecosts")

      html = render(index_live)
      assert html =~ "Waste cost updated successfully"
    end

    test "deletes waste_cost in listing", %{conn: conn, waste_cost: waste_cost} do
      {:ok, index_live, _html} = live(conn, ~p"/wastecosts")

      assert index_live |> element("#wastecosts-#{waste_cost.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#wastecosts-#{waste_cost.id}")
    end
  end

  describe "Show" do
    setup [:create_waste_cost]

    test "displays waste_cost", %{conn: conn, waste_cost: waste_cost} do
      {:ok, _show_live, html} = live(conn, ~p"/wastecosts/#{waste_cost}")

      assert html =~ "Show Waste cost"
    end

    test "updates waste_cost within modal", %{conn: conn, waste_cost: waste_cost} do
      {:ok, show_live, _html} = live(conn, ~p"/wastecosts/#{waste_cost}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Waste cost"

      assert_patch(show_live, ~p"/wastecosts/#{waste_cost}/show/edit")

      assert show_live
             |> form("#waste_cost-form", waste_cost: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#waste_cost-form", waste_cost: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/wastecosts/#{waste_cost}")

      html = render(show_live)
      assert html =~ "Waste cost updated successfully"
    end
  end
end
