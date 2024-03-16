defmodule EcoService.EcoService.Waste do
  use Ecto.Schema
  import Ecto.Changeset

  alias EcoService.EcoService.Community

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "wastes" do
    field :comments, :string
    field :date, :date
    field :glass_bags, :integer
    field :kg_of_glass, :decimal
    field :kg_of_mixed, :decimal
    field :kg_of_paper, :decimal
    field :kg_of_plastic, :decimal
    field :kg_of_sanitory, :decimal
    field :kg_of_seg_lf, :decimal
    field :mixed_bags, :integer
    field :paper_bags, :integer
    field :plastic_bags, :integer
    field :sanitory_bags, :integer
    field :seg_lf_bags, :integer

    belongs_to :community, Community

    timestamps()
  end

  @doc false
  def changeset(waste, attrs) do
    waste
    |> cast(attrs, [:date, :glass_bags, :mixed_bags, :plastic_bags, :paper_bags, :seg_lf_bags, :sanitory_bags, :kg_of_glass, :kg_of_mixed, :kg_of_plastic, :kg_of_paper, :kg_of_seg_lf, :kg_of_sanitory, :comments])
    |> validate_required([:date, :glass_bags, :mixed_bags, :plastic_bags, :paper_bags, :seg_lf_bags, :sanitory_bags, :kg_of_glass, :kg_of_mixed, :kg_of_plastic, :kg_of_paper, :kg_of_seg_lf, :kg_of_sanitory, :comments])
  end

  def add_waste_changeset(waste, attrs) do
    waste
    |> cast(attrs, [:community_id,  :date, :glass_bags, :mixed_bags, :plastic_bags, :paper_bags, :seg_lf_bags, :sanitory_bags, :kg_of_glass, :kg_of_mixed, :kg_of_plastic, :kg_of_paper, :kg_of_seg_lf, :kg_of_sanitory, :comments])
    |> validate_required([:date, :community_id])
  end
end
