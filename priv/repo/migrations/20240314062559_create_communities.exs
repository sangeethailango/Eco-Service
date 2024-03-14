defmodule EcoService.Repo.Migrations.CreateCommunities do
  use Ecto.Migration

  def change do
    create table(:communities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :location_area_zone, :string

      timestamps()
    end
  end
end
