defmodule EcoService.Total.WasteCost do
  use Ecto.Schema
  import Ecto.Changeset

  schema "wastecosts" do
    field :cost_of_glass_waste, :decimal
    field :cost_of_mix_waste, :decimal
    field :cost_of_paper_waste, :decimal
    field :cost_of_plastic_waste, :decimal
    field :cost_of_sanitory_waste, :decimal
    field :cost_of_seg_lf_waste, :decimal

    timestamps()
  end

  @doc false
  def changeset(waste_cost, attrs) do
    waste_cost
    |> cast(attrs, [:cost_of_mix_waste, :cost_of_paper_waste, :cost_of_plastic_waste, :cost_of_sanitory_waste, :cost_of_seg_lf_waste, :cost_of_glass_waste])
    |> validate_required([:cost_of_mix_waste, :cost_of_paper_waste, :cost_of_plastic_waste, :cost_of_sanitory_waste, :cost_of_seg_lf_waste, :cost_of_glass_waste])
  end
end
