defmodule SheetLiveWeb.Router do
  use SheetLiveWeb, :router

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

  scope "/", SheetLiveWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/game", PageController, :game
    get "/svg", PageController, :svg
    get "/chart", PageController, :chart

    post "/login", PageController, :login
  end

  # Other scopes may use custom stacks.
  # scope "/api", SheetLiveWeb do
  #   pipe_through :api
  # end
end
