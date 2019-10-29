defmodule SheetLive.Sheet do
  use GenServer

  @palette %{
    "0" => "white",
    "1" => "black",
    "2" => "red"
  }

  defstruct board: [
              ~w(0 0 0 0 0 0 0 0 0 0),
              ~w(0 0 2 2 1 1 1 1 0 0),
              ~w(0 0 2 2 1 1 1 1 0 0),
              ~w(0 0 2 2 0 0 1 1 0 0),
              ~w(0 0 2 2 1 1 1 1 0 0),
              ~w(0 0 2 2 1 1 1 1 0 0),
              ~w(0 0 2 2 0 1 1 0 0 0),
              ~w(0 0 2 2 0 1 1 0 0 0),
              ~w(0 0 2 2 0 1 1 0  0),
              ~w(0 0 0 0 0 0 0 0 0 0)
            ],
            positions: %{},
            participants: %{}

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def connected(participant), do: GenServer.call(__MODULE__, {:connected, participant})
  def disconnected(participant), do: GenServer.call(__MODULE__, {:disconnected, participant})
  def get_state(), do: GenServer.call(__MODULE__, {:get_state})
  def place(placeEvent), do: GenServer.call(__MODULE__, {:place, placeEvent})

  def get_color(index), do: Map.get(@palette, index)

  def handle_call({:connected, participant}, _, state) do
    nextState =
      Map.put(state, :participants, Map.put(state.participants, participant.id, participant))

    {:reply, nextState, nextState}
  end

  def handle_call({:disconnected, participant}, _, state) do
    nextState = Map.put(state, :participants, Map.delete(state.participants, participant.id))

    {:reply, nextState, nextState}
  end

  def handle_call({:place, placeEvent}, _, state) do
    %{rowIndex: rowIndex, cellIndex: cellIndex} = placeEvent

    rowMap =
      state
      |> Map.get(:positions)
      |> Map.get(rowIndex)

    nextRowMap =
      case rowMap do
        nil -> %{cellIndex => placeEvent.username}
        _ -> Map.put(rowMap, cellIndex, placeEvent.username)
      end

    nextPositions = Map.put(state.positions, rowIndex, nextRowMap)
    nextState = Map.put(state, :positions, nextPositions)

    {:reply, nextState, nextState}
  end

  def handle_call(_, _, state) do
    {:noreply, state}
  end
end
