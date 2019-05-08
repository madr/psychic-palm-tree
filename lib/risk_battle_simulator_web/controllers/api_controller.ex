defmodule RiskBattleSimulatorWeb.ApiController do
  use RiskBattleSimulatorWeb, :controller
  import Ecto.Changeset

  @default_num 300

  def index(conn, _) do
    payload = %{
      params: [
        %{
          :name => "attacking",
          :type => "integer",
          :required => "yes"
        },
        %{
          :name => "has_hero",
          :type => "bool",
          :required => "no",
          :default => false
        },
        %{
          :name => "defending",
          :type => "integer",
          :required => "yes"
        },
        %{
          :name => "is_fort",
          :type => "bool",
          :required => "no",
          :default => false
        },
        %{
          :name => "battles",
          :type => "integer",
          :required => "no",
          :default => @default_num
        }
      ]
    }

    json(conn, payload)
  end

  def create(conn, data) do
    simulation = %Simulation{}
    changeset = Simulation.changeset(simulation, data)

    case changeset.valid? do
      true -> json(conn, changeset |> simulate)
      false -> json(conn, %{errors: "Sorry, bad input."})
    end
  end

  defp simulate(changeset) do
    data =
      changeset
      |> apply_changes
      |> Map.from_struct()

    attacking = data |> Map.fetch!(:attacking) |> IO.inspect()
    defending = data |> Map.fetch!(:defending) |> IO.inspect()
    battles = data |> Map.fetch!(:battles) |> IO.inspect()
    options = data |> get_options |> IO.inspect()
    RiskDice.simulate(attacking, defending, battles, options)
  end

  defp get_options(%{has_hero: true, is_fort: true}), do: ["has_hero", "is_fort"]

  defp get_options(%{has_hero: false, is_fort: true}), do: ["is_fort"]

  defp get_options(%{has_hero: true, is_fort: false}), do: ["has_hero"]

  defp get_options(%{has_hero: false, is_fort: false}), do: []
end