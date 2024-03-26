defmodule EcoService.Repo.Migrations.CreateSchedules do
  use Ecto.Migration

  def change do
    create table(:schedules, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :day_of_week, :string

      timestamps()
    end
  end
end
