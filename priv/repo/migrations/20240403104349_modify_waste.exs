defmodule EcoService.Repo.Migrations.ModifyWaste do
  use Ecto.Migration

  def change do
    alter table(:wastes) do
      modify :glass_bags, :decimal
      modify :mixed_bags, :decimal
      modify :paper_bags, :decimal
      modify :plastic_bags, :decimal
      modify :sanitory_bags, :decimal
    end
  end
end
