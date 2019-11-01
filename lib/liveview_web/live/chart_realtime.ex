defmodule SheetLiveWeb.ChartRealtime do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
      <svg class="chart" width="420" height="150" aria-labelledby="title desc" role="img">
          <title id="title">A bar chart showing information</title>
          <desc id="desc">4 apples; 8 bananas; 15 kiwis; 16 oranges; 23 lemons</desc>
          <g class="bar">
            <rect width="<%= @count %>0" height="19"></rect>
            <text x="<%= @count %>5" y="9.5" dy=".35em">4 apples</text>
          </g>
          <g class="bar">
            <rect width="80" height="19" y="20"></rect>
            <text x="85" y="28" dy=".35em">8 bananas</text>
          </g>
          <g class="bar">
            <rect width="150" height="19" y="40"></rect>
            <text x="150" y="48" dy=".35em">15 kiwis</text>
          </g>
          <g class="bar">
            <rect width="160" height="19" y="60"></rect>
            <text x="161" y="68" dy=".35em">16 oranges</text>
          </g>
          <g class="bar">
            <rect width="230" height="19" y="80"></rect>
            <text x="235" y="88" dy=".35em">23 lemons</text>
          </g>
        </svg>

    """
  end

  def mount(_, socket) do
    if connected?(socket), do: Process.send_after(self(), :tick, 500)

    {:ok,
     assign(socket,
       time: :calendar.local_time(),
       count: 0
     )}
  end

  def handle_info(:tick, %{assigns: %{count: count}} = socket) do
    Process.send_after(self(), :tick, 500)

    {:noreply,
     assign(socket,
       time: :calendar.local_time(),
       count: :rand.uniform(23)
     )}
  end

  # def handle_info(:tick, %{assigns: %{count: count}} = socket) do
  #   Process.send_after(self(), :tick, 500)

  #   {:noreply,
  #    assign(socket,
  #      time: :calendar.local_time(),
  #      count: socket.assigns.count + 1
  #    )}
  # end
end
