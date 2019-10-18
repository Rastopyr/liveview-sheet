defmodule SheetLiveWeb.PageController do
  use SheetLiveWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
