defmodule EcoService.Repo.Migrations.AlterWaste do
  use Ecto.Migration

  def change do
    alter table(:wastes) do
      remove :sef_lf_bags, :integer
      add :seg_lf_bags, :integer
      remove :kg_of_sef_lf, :decimal
      add :kg_of_seg_lf, :decimal
    end
  end
end
