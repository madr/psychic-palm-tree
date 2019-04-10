defmodule RiskBattleSimulatorWeb.Router do
  use RiskBattleSimulatorWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RiskBattleSimulatorWeb do
    pipe_through :api

    resources "/", ApiController, only: [:index, :create]
  end

  scope "/", RiskBattleSimulatorWeb do
    pipe_through :browser

    get "/:attacking/vs/:defending", BattleController, :simulation
    get "/", BattleController, :simulation
    live "/live", SimulateLive
  end
end
