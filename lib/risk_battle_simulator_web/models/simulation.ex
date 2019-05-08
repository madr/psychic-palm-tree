defmodule Simulation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "simulations" do
    field(:attacking, :integer)
    field(:defending, :integer)
    field(:has_hero, :boolean, default: false)
    field(:is_fort, :boolean, default: false)
    field(:battles, :integer, default: 300)
  end

  def changeset(simulation, params \\ %{}) do
    simulation
    |> cast(params, [:attacking, :defending, :has_hero, :is_fort, :battles])
    |> validate_required([:attacking, :defending])
    |> validate_number(:attacking, greater_than: 0)
    |> validate_number(:defending, greater_than: 0)
    |> validate_number(:battles, less_than_or_equal_to: 500, greater_than_or_equal_to: 100)
  end
end
