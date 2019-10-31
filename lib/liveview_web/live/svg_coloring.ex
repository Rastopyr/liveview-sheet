defmodule SheetLiveWeb.SVGColoring do
  use Phoenix.LiveView

  @colors %{
    "white" => "#fff",
    "black" => "#000",
    "red" => "#ff0000"
  }

  def render(assigns) do
    ~L"""
      <div class="lobby">
        <h1>SVG</h1>

          <div style="display: flex; flex-direction: row;">
            <%= for { { colorName, colorCode }, _  } <- Enum.with_index(@colors) do %>
              <div phx-click="chooseColor" phx-value-color="<%= colorName %>" class="colorChooser">
                <div class="colorElement <%= if @color == colorCode do %>choosed<% end %>" style="background-color: <%= colorCode %>;"></div>
                <%= colorName %>
              </div>

            <% end %>
          </div>

          <svg xmlns="http://www.w3.org/2000/svg" width="466" height="466" viewBox="-40 -40 80 80">
            <circle
              id="1"
              phx-value-id="1"
              phx-click="fillFigure"
              style="<%= if isFiledFigure?(@filledFigures, "1") do %>fill: <%= @filledFigures["1"] %> <% end %>"
              class="figure"
              r="39"/>
            <path
              id="2"
              phx-value-id="2"
              phx-click="fillFigure"
              class="figure"
              d="M0,38a38,38 0 0 1 0,-76a19,19 0 0 1 0,38a19,19 0 0 0 0,38"
              fill="#fff"
              style="<%= if isFiledFigure?(@filledFigures, "2") do %>fill: <%= @filledFigures["2"] %> <% end %>"
            />
            <circle
              id="3"
              phx-value-id="3"
              phx-click="fillFigure"
              class="figure"
              cy="19"
              r="5"
              fill="#fff"
              style="<%= if isFiledFigure?(@filledFigures, "3") do %>fill: <%= @filledFigures["3"] %> <% end %>"
              />
            <circle
              id="4"
              phx-value-id="4"
              phx-click="fillFigure"
              class="figure"
              cy="-19"
              r="5"
              style="<%= if isFiledFigure?(@filledFigures, "4") do %>fill: <%= @filledFigures["4"] %> <% end %>"
              />
          </svg>
        </div>

        <style>
          .colorChooser {
            text-align: center;
          }

          .colorElement {
            width: 140px;
            height: 40px;
            position: relative;
            text-align: center;
            cursor: pointer;
            box-shadow: 0 2px 3px #ccc;

            padding: 3px;
            margin: 0 10px;
            border-radius: 5px;
            border: 2px solid #ccc;
          }

          .colorElement.choosed {
            border: 2px solid blue;
          }

          <%= if @color != nil do %>
            .figure:hover {
              fill: <%= @color %> !important;
            }
          <% end %>
        </style>
      </div>
    """
  end

  def isFiledFigure?(filledFigures, id) do
    filledFigures[id] != nil
  end

  def mount(_, socket) do
    {:ok,
     assign(socket,
       colors: @colors,
       color: nil,
       filledFigures: %{}
     )}
  end

  def handle_event("chooseColor", %{"color" => color}, socket) do
    {:noreply,
     assign(socket,
       color: @colors[color]
     )}
  end

  def handle_event(
        "fillFigure",
        %{"id" => figureId},
        socket
      ) do
    {:noreply,
     assign(socket,
       filledFigures: Map.put(socket.assigns.filledFigures, figureId, socket.assigns.color)
     )}
  end
end
