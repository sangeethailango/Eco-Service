defmodule EcoService.Repo.Migrations.CreateWastes do
  use Ecto.Migration

  def change do
    create table(:wastes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :date, :date
      add :glass_bags, :integer
      add :mixed_bags, :integer
      add :plastic_bags, :integer
      add :paper_bags, :integer
      add :sef_lf_bags, :integer
      add :sanitory_bags, :integer
      add :kg_of_glass, :decimal
      add :kg_of_mixed, :decimal
      add :kg_of_plastic, :decimal
      add :kg_of_paper, :decimal
      add :kg_of_sef_lf, :decimal
      add :kg_of_sanitory, :decimal
      add :comments, :string
      add :community_id, references(:communities, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create index(:wastes, [:community_id])
  end
end
