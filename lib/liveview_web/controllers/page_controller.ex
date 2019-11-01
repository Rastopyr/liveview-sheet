defmodule SheetLiveWeb.PageController do
  use SheetLiveWeb, :controller

  def index(conn, _params) do
    username = get_session(conn, :username)

    render(conn, "index.html",
      token: get_csrf_token(),
      username: username
    )
  end

  def game(conn, _params) do
    username = get_session(conn, :username)

    case username do
      nil -> redirect(conn, to: "/")
      _ -> render(conn, "game.html", username: username)
    end
  end

  def login(conn, %{"user" => %{"username" => username}}) do
    next_conn = put_session(conn, :username, username)

    redirect(next_conn, to: "/game")
  end

  def svg(conn, _params) do
    render(conn, "svg.html")
  end

  def chart(conn, _params) do
    render(conn, "chart.html")
  end
end
