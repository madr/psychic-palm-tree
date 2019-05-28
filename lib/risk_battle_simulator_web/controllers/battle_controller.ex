defmodule RiskBattleSimulatorWeb.BattleController do
  use RiskBattleSimulatorWeb, :controller

  import Ecto.Changeset

  def simulation(conn, params) do
    simulation = %Simulation{}
    changeset = Simulation.changeset(simulation, params)

    case changeset.valid? do
      true -> render(conn, "battle.html", response(changeset))
    end
  end

  defp simulate(attacking_troops, defending_troops, num, options) do
    RiskDice.simulate(attacking_troops, defending_troops, num, options)
  end

  defp response(%{
        attacking: attacking_troops,
        defending: defending_troops,
        has_hero: has_hero,
        is_fort: is_fort,
        battles: num
    }) do
    options = Simulation.get_options(has_hero, is_fort)

    result = simulate(attacking_troops, defending_troops, num, options)

    %{
      result: result,
      values: %{
        :attacking => attacking_troops,
        :defending => defending_troops,
        :has_hero => "has_hero" in options,
        :is_fort => "is_fort" in options,
        :battles => num
      }
    }
  end
  defp response(changeset) do
    data =
      changeset
      |> apply_changes()
      |> Map.from_struct()

    %{
      __meta__: _meta,
      has_hero: has_hero,
      is_fort: is_fort,
      attacking: attacking,
      defending: defending,
      battles: battles
    } = data

    options = Simulation.get_options(has_hero, is_fort)
    result = RiskDice.simulate(attacking, defending, battles, options)

    %{
      result: result,
      values: %{
        :attacking => attacking,
        :defending => defending,
        :has_hero => "has_hero" in options,
        :is_fort => "is_fort" in options,
        :battles => battles
      }
    }
  end
end
