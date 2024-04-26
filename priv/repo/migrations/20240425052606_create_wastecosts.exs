defmodule EcoService.Repo.Migrations.CreateWastecosts do
  use Ecto.Migration

  def change do
    create table(:wastecosts) do
      add :cost_of_mix_waste, :decimal
      add :cost_of_paper_waste, :decimal
      add :cost_of_plastic_waste, :decimal
      add :cost_of_sanitory_waste, :decimal
      add :cost_of_seg_lf_waste, :decimal
      add :cost_of_glass_waste, :decimal

      timestamps()
    end
  end
end
