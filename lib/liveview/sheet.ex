defmodule SheetLive.Sheet do
  # alias SheetLiveWeb.SheetState

  defstruct board: [
              ~w(0 0 0 0 0 0 0 0 0 0),
              ~w(0 0 1 1 1 1 1 1 0 0),
              ~w(0 0 1 1 1 1 1 1 0 0),
              ~w(0 0 1 1 0 0 1 1 0 0),
              ~w(0 0 1 1 1 1 1 1 0 0),
              ~w(0 0 1 1 1 1 1 1 0 0),
              ~w(0 0 1 1 0 1 1 0 0 0),
              ~w(0 0 1 1 0 1 1 0 0 0),
              ~w(0 0 0 0 0 0 0 0 0 0),
              ~w(0 0 0 0 0 0 0 0 0 0)
            ],
            participants: %{}

  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def connected(participant), do: GenServer.call(__MODULE__, {:connected, participant})
  def disconnected(participant), do: GenServer.call(__MODULE__, {:disconnected, participant})
  # def placeCell(cell, position), do: GenServer.call(__MODULE__, {:placeCell, cell, position})

  def handle_call({:connected, participant}, _, state) do
    nextState =
      Map.put(state, :participants, Map.put(state.participants, participant.id, participant))

    {:reply, nextState, nextState}
  end

  def handle_call({:disconnected, participant}, _, state) do
    nextState = Map.put(state, :participants, Map.delete(state.participants, participant.id))

    {:reply, nextState, nextState}
  end

  def handle_call(_, _, state) do
    {:noreply, state}
  end
end
