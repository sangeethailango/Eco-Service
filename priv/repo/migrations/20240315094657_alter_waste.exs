defmodule EcoService.Repo.Migrations.AlterWaste do
  use Ecto.Migration

  def change do
    alter table(:wastes) do
      remove :sef_lf_bags, :integer
      add :seg_lf_bags, :integer
      remove :kg_of_sef_lf, :integer
      add :kg_of_seg_lf, :integer
    end
  end
end
