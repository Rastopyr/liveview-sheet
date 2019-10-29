defmodule SheetLiveWeb.SheetGame do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
        <div class="lobby">
          <h1>Game</h1>

          <div>
            <%= for {row, rowIndex} <- Enum.with_index(@state.board) do %>
              <div style="display: flex; flex-direction: row;">
                <%= for {cell, cellIndex} <- Enum.with_index(row) do %>
                  <div
                    phx-click="place"
                    phx-value-row="<%= rowIndex %>"
                    phx-value-cell="<%= cellIndex %>"
                    class="cell <%= unless isPlaced?(@state.positions, rowIndex, cellIndex) do %>inactive<% end %>"
                    style="
                      display: inline-block;
                      width: 40px; height: 40px;
                    "
                  >
                    <div
                      class="background"
                      style="
                        width: 100%;
                        background-color: <%= SheetLive.Sheet.get_color(cell) %>;
                        height: 100%;
                      "
                    >
                    </div>
                  </div>
                <% end %>
              </div>
            <% end %>
          </div>
        </div>
    """
  end

  def isPlaced?(positions, row, cell) do
    case isPlaced?(positions, Integer.to_string(row)) do
      false -> false
      true -> isPlaced?(positions[Integer.to_string(row)], Integer.to_string(cell))
    end
  end

  def isPlaced?(positions, index), do: positions[index] != nil

  def mount(session, socket) do
    if connected?(socket), do: Process.send_after(self(), :tick, 500)

    {:ok,
     assign(socket,
       time: :calendar.local_time(),
       username: session.username,
       state: :sys.get_state(SheetLive.Sheet)
     )}
  end

  def handle_event("place", %{"row" => rowIndex, "cell" => cellIndex}, socket) do
    nextState =
      SheetLive.Sheet.place(%{
        username: socket.assigns.username,
        rowIndex: rowIndex,
        cellIndex: cellIndex
      })

    # IO.inspect(socket.assigns.state.positions[rowIndex] != nil)

    {:noreply,
     assign(socket,
       time: :calendar.local_time(),
       state: nextState
     )}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 500)

    {:noreply,
     assign(socket,
       time: :calendar.local_time(),
       state: :sys.get_state(SheetLive.Sheet)
     )}
  end
end
