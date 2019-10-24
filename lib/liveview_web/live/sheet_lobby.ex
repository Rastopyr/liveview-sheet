defmodule SheetLiveWeb.SheetLobby do
  use Phoenix.LiveView
  import Logger

  def render(assigns) do
    ~L"""
       <div class="lobby">
          <h1>Game Lobby</h1>


          <%= if Map.has_key?(@session, "id") do %>
            <%= @session["id"] %>
          <% else %>
            <form phx-submit="login">
              <input name="user[username]" type="text" phx-debounce="blur" />

              <button type="submit" phx-disable-with="Saving...">Save</button>
            </form>
          <% end %>




      </div>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: Process.send_after(self(), :tick, 1000)

    is

    {:ok,
     assign(socket,
       state: %SheetLive.Sheet{},
       session: %{},
       time: :calendar.local_time()
     )}
  end

  def user_id() do
    :crypto.strong_rand_bytes(64) |> Base.url_encode64() |> binary_part(0, 64)
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, assign(socket, time: :calendar.local_time())}
  end

  def handle_event("login", %{"user" => %{"username" => username}}, socket) do
    userId = user_id()

    nextState =
      SheetLive.Sheet.connected(%SheetLive.Participant{
        id: userId,
        username: username
      })

    live_redirect(socket, SheetLiveWeb.SheetGame)

    {:noreply,
     assign(socket,
       state: nextState,
       session: %{
         "id" => userId
       }
     )}
  end
end
