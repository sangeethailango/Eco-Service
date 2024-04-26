defmodule EcoService.Total do
  @moduledoc """
  The Total context.
  """

  import Ecto.Query, warn: false
  alias EcoService.Repo

  alias EcoService.Total.WasteCost

  @doc """
  Returns the list of wastecosts.

  ## Examples

      iex> list_wastecosts()
      [%WasteCost{}, ...]

  """
  def list_wastecosts do
    WasteCost
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  @doc """
  Creates a waste_cost.

  ## Examples

      iex> create_waste_cost(%{field: value})
      {:ok, %WasteCost{}}

      iex> create_waste_cost(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_waste_cost(attrs \\ %{}) do
    %WasteCost{}
    |> WasteCost.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking waste_cost changes.

  ## Examples

      iex> change_waste_cost(waste_cost)
      %Ecto.Changeset{data: %WasteCost{}}

  """
  def change_waste_cost(%WasteCost{} = waste_cost, attrs \\ %{}) do
    WasteCost.changeset(waste_cost, attrs)
  end
end
