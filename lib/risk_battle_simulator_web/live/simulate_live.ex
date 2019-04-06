defmodule RiskBattleSimulatorWeb.SimulateLive do
  @moduledoc """
  Run simulation every time the any form field is updated.
  """
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <form phx-change="simulate" class="live">
      <%= if @result do %>
        <output>
          <h1><%= @result.win_rate %>% chans till vinst</h1>
          <p>
            Trupper kvar: <strong><%= @result.avg_remaining %></strong> (medel), 
            <strong><%= @result.med_remaining %></strong> (median)
          </p>
        </output>
      <% else %>
        <h1>RISK Battle Simulator</h1>
      <% end %>
      <fieldset>
        <legend>Anfallande trupper</legend>
        <p>
          <label for="attacking">Antal</label>
          <input type="number" <%= if @loading, do: "readonly" %> name="attacking" id="attacking" value="<%= @attacking %>" pattern="0-9+" required>
        </p>
        <p>
          <input type="checkbox" <%= if @loading, do: "readonly" %> name="options[]" <%= if @has_hero do %>checked<% end %> id="hasHero" value="has_hero">
          <label for="hasHero">Har hjälte</label>
        </p>
      </fieldset>
      <fieldset>
        <legend>Försvarande trupper</legend>
        <p>
          <label for="defending">Antal</label>
          <input type="number" <%= if @loading, do: "readonly" %> name="defending" id="defending" value="<%= @defending %>" pattern="0-9+" required>
        </p>
        <p>
          <input type="checkbox" <%= if @loading, do: "readonly" %> name="options[]" <%= if @is_fort do %>checked<% end %> id="isFort" value="is_fort">
          <label for="isFort">Befästning</label>
        </p>
      </fieldset>
      <p>
        <label for="battles">Antal simulationer</label>
        <input type="number" <%= if @loading, do: "readonly" %> step="100" name="battles" id="battles" value="<%= @battles %>" pattern="0-9+" required>
        <small>Högre antal ger bättre sannolikhet</small>
      </p>
    </form>
    """
  end

  def mount(_session, socket) do
    {:ok,
     assign(
       socket,
       attacking: 3,
       defending: 2,
       battles: 300,
       has_hero: false,
       is_fort: false,
       result: nil,
       loading: false
     )}
  end

  def handle_event(
        "simulate",
        %{
          "attacking" => attacking,
          "defending" => defending,
          "battles" => battles,
          "options" => options
        },
        socket
      ) do
    [attacking, defending, battles] =
      [attacking, defending, battles] |> Enum.map(&String.to_integer/1)

    result = RiskDice.simulate(attacking, defending, battles, options)

    {:noreply,
     assign(socket,
       attacking: attacking,
       defending: defending,
       battles: battles,
       has_hero: "has_hero" in options,
       is_fort: "is_fort" in options,
       result: result
     )}
  end

  def handle_event(
        "simulate",
        %{
          "attacking" => attacking,
          "defending" => defending,
          "battles" => battles
        },
        socket
      ) do
    [attacking, defending, battles] =
      [attacking, defending, battles] |> Enum.map(&String.to_integer/1)

    result = RiskDice.simulate(attacking, defending, battles)

    {:noreply,
     assign(socket,
       attacking: attacking,
       defending: defending,
       battles: battles,
       has_hero: false,
       is_fort: false,
       result: result
     )}
  end

  # def handle_info({:simulate, query}, socket) do
  #  {result, _} = System.cmd("dict", ["#{query}"], stderr_to_stdout: true)
  #  {:noreply, assign(socket, loading: false, result: result)}
  # end
end
