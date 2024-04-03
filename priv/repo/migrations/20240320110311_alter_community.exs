defmodule EcoService.Repo.Migrations.AlterCommunity do
  use Ecto.Migration

  def change do
    alter table(:communities) do
      add :schedule_id, references(:schedules, type: :binary_id, on_delete: :nothing)
      add :lat, :decimal
      add :long, :decimal
      add :gate_photo_file_name, :string
    end
    create index(:communities, [:schedule_id])
  end
end
