defmodule EcoService.Repo.Migrations.CreateCommunities do
  use Ecto.Migration

  def change do
    create table(:communities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :location_area_zone, :string
      add :lat, :decimal
      add :long, :decimal
      add :gate_photo_file_name, :string
      add :is_aurovillian, :boolean
      add :contact_person_name, :string
      add :contact_person_phone_number, :integer
      add :contact_person_email, :string
      add :fs_acc_num, :string

      add :schedule_id, references(:schedules, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create index(:communities, [:schedule_id])
  end
end
