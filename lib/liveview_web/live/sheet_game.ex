defmodule SheetLiveWeb.SheetGame do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
       <div class="lobby">
          <h1>Game</h1>

          <div>
          <%= for {row, index} <- Enum.with_index(@state.board) do %>
          <div style="display: flex">
            <%= for {cell, index} <- Enum.with_index(row) do %>
              <div
                style="
                  display: inline-block;
                  background-color: <%= SheetLive.Sheet.get_color(cell) %>;
                  width: 40px; height: 40px;
                "
              >
              </div>
            <% end %>
          </div>
        <% end %>
          </div>
      </div>
    """
  end

  def mount(session, socket) do
    if connected?(socket), do: Process.send_after(self(), :tick, 1000)

    {:ok,
     assign(socket,
       time: :calendar.local_time(),
       username: session.username,
       state: :sys.get_state(SheetLive.Sheet)
     )}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, assign(socket, time: :calendar.local_time())}
  end
end
