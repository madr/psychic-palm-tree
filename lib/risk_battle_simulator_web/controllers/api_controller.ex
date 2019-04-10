defmodule RiskBattleSimulatorWeb.ApiController do
  use RiskBattleSimulatorWeb, :controller

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
          :name => "hasHero",
          :type => "bool",
          :required => "no",
          :default => 0
        },
        %{
          :name => "defending",
          :type => "integer",
          :required => "yes"
        },
        %{
          :name => "isFort",
          :type => "bool",
          :required => "no",
          :default => 0
        },
        %{
          :name => "battles",
          :type => "integer",
          :required => "no",
          :default => 300
        }
      ]
    }

    json(conn, payload)
  end

  def create(conn, %{
        "attacking" => attacking,
        "defending" => defending
      }) do
    payload = [attacking, defending]
    |> Enum.map(&String.to_integer/1)
    |> simulate

    json(conn, payload)
  end

  defp simulate(_, options \\ [])

  defp simulate([attacking_troops, defending_troops, num], options) do
    RiskDice.simulate(attacking_troops, defending_troops, num, options)
  end

  defp simulate([attacking_troops, defending_troops], options) do
    RiskDice.simulate(attacking_troops, defending_troops, @default_num, options)
  end
end