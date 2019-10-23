defmodule SheetLiveWeb.PageController do
  use SheetLiveWeb, :controller

  def index(conn, _params) do
    live_render(conn, SheetLiveWeb.SheetLobby)
  end
end
