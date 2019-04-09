defmodule RiskBattleSimulatorWeb.BattleController do
  use RiskBattleSimulatorWeb, :controller

  @default_num 300
  @default_attacking 3
  @default_defending 2

  def simulation(conn, %{
        "attacking" => attacking_troops,
        "defending" => defending_troops,
        "battles" => num,
        "options" => options
      }) do
    results = response(attacking_troops, defending_troops, num, options)
    render(conn, "battle.html", results)
  end

  def simulation(conn, %{
        "attacking" => attacking_troops,
        "defending" => defending_troops,
        "battles" => num
      }) do
    results = response(attacking_troops, defending_troops, num)
    render(conn, "battle.html", results)
  end

  def simulation(conn, %{
      "attacking" => attacking_troops,
      "defending" => defending_troops,
      }) do
    results = response(attacking_troops, defending_troops, Integer.to_string(@default_num))
    render(conn, "battle.html", results)
  end

  def simulation(conn, _) do
    render(conn, "battle.html", %{
      result: false,
      values: %{
        :attacking => @default_attacking,
        :defending => @default_defending,
        :has_hero => false,
        :is_fort => false,
        :battles => @default_num
      }
    })
  end

  defp simulate([attacking_troops, defending_troops, num], options) do
    RiskDice.simulate(attacking_troops, defending_troops, num, options)
  end

  defp response(attacking_troops, defending_troops, num, options \\ %{}) do
    result =
      [attacking_troops, defending_troops, num]
      |> Enum.map(&String.to_integer/1)
      |> simulate(options)

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
end
