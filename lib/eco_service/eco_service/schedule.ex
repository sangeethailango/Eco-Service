defmodule EcoService.EcoService.Schedule do
  use Ecto.Schema
  import Ecto.Changeset

  alias EcoService.EcoService.Community

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "schedules" do
    field :day_of_week, :string

    has_many :communities, Community
    timestamps()
  end

  @doc false
  def changeset(schedule, attrs) do
    schedule
    |> cast(attrs, [:day_of_week])
    |> validate_required([:day_of_week])
  end
end
