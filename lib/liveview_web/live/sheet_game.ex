defmodule SheetLiveWeb.SheetGame do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
       <div class="lobby">
          <h1>Game</h1>
      </div>
    """
  end

  def mount(_session, socket) do
    if connected?(socket), do: Process.send_after(self(), :tick, 1000)

    {:ok,
     assign(socket,
       time: :calendar.local_time()
     )}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, assign(socket, time: :calendar.local_time())}
  end
end
