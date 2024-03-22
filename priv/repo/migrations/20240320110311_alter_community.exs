defmodule EcoService.Repo.Migrations.AlterCommunity do
  use Ecto.Migration

  def change do
    alter table(:communities) do
      add :schedule_id, references(:schedules, type: :binary_id, on_delete: :nothing)
    end
    create index(:communities, [:schedule_id])

  end
end
