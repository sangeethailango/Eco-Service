defmodule EcoService.TotalFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EcoService.Total` context.
  """

  @doc """
  Generate a waste_cost.
  """
  def waste_cost_fixture(attrs \\ %{}) do
    {:ok, waste_cost} =
      attrs
      |> Enum.into(%{
        cost_of_glass_waste: "120.5",
        cost_of_mix_waste: "120.5",
        cost_of_paper_waste: "120.5",
        cost_of_plastic_waste: "120.5",
        cost_of_sanitory_waste: "120.5",
        cost_of_seg_lf_waste: "120.5"
      })
      |> EcoService.Total.create_waste_cost()

    waste_cost
  end
end
