defmodule EcoService.TotalTest do
  use EcoService.DataCase

  alias EcoService.Total

  describe "wastecosts" do
    alias EcoService.Total.WasteCost

    import EcoService.TotalFixtures

    @invalid_attrs %{cost_of_glass_waste: nil, cost_of_mix_waste: nil, cost_of_paper_waste: nil, cost_of_plastic_waste: nil, cost_of_sanitory_waste: nil, cost_of_seg_lf_waste: nil}

    test "list_wastecosts/0 returns all wastecosts" do
      waste_cost = waste_cost_fixture()
      assert Total.list_wastecosts() == [waste_cost]
    end

    test "get_waste_cost!/1 returns the waste_cost with given id" do
      waste_cost = waste_cost_fixture()
      assert Total.get_waste_cost!(waste_cost.id) == waste_cost
    end

    test "create_waste_cost/1 with valid data creates a waste_cost" do
      valid_attrs = %{cost_of_glass_waste: "120.5", cost_of_mix_waste: "120.5", cost_of_paper_waste: "120.5", cost_of_plastic_waste: "120.5", cost_of_sanitory_waste: "120.5", cost_of_seg_lf_waste: "120.5"}

      assert {:ok, %WasteCost{} = waste_cost} = Total.create_waste_cost(valid_attrs)
      assert waste_cost.cost_of_glass_waste == Decimal.new("120.5")
      assert waste_cost.cost_of_mix_waste == Decimal.new("120.5")
      assert waste_cost.cost_of_paper_waste == Decimal.new("120.5")
      assert waste_cost.cost_of_plastic_waste == Decimal.new("120.5")
      assert waste_cost.cost_of_sanitory_waste == Decimal.new("120.5")
      assert waste_cost.cost_of_seg_lf_waste == Decimal.new("120.5")
    end

    test "create_waste_cost/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Total.create_waste_cost(@invalid_attrs)
    end

    test "update_waste_cost/2 with valid data updates the waste_cost" do
      waste_cost = waste_cost_fixture()
      update_attrs = %{cost_of_glass_waste: "456.7", cost_of_mix_waste: "456.7", cost_of_paper_waste: "456.7", cost_of_plastic_waste: "456.7", cost_of_sanitory_waste: "456.7", cost_of_seg_lf_waste: "456.7"}

      assert {:ok, %WasteCost{} = waste_cost} = Total.update_waste_cost(waste_cost, update_attrs)
      assert waste_cost.cost_of_glass_waste == Decimal.new("456.7")
      assert waste_cost.cost_of_mix_waste == Decimal.new("456.7")
      assert waste_cost.cost_of_paper_waste == Decimal.new("456.7")
      assert waste_cost.cost_of_plastic_waste == Decimal.new("456.7")
      assert waste_cost.cost_of_sanitory_waste == Decimal.new("456.7")
      assert waste_cost.cost_of_seg_lf_waste == Decimal.new("456.7")
    end

    test "update_waste_cost/2 with invalid data returns error changeset" do
      waste_cost = waste_cost_fixture()
      assert {:error, %Ecto.Changeset{}} = Total.update_waste_cost(waste_cost, @invalid_attrs)
      assert waste_cost == Total.get_waste_cost!(waste_cost.id)
    end

    test "delete_waste_cost/1 deletes the waste_cost" do
      waste_cost = waste_cost_fixture()
      assert {:ok, %WasteCost{}} = Total.delete_waste_cost(waste_cost)
      assert_raise Ecto.NoResultsError, fn -> Total.get_waste_cost!(waste_cost.id) end
    end

    test "change_waste_cost/1 returns a waste_cost changeset" do
      waste_cost = waste_cost_fixture()
      assert %Ecto.Changeset{} = Total.change_waste_cost(waste_cost)
    end
  end
end
