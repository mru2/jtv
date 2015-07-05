defmodule Jtv.Counter.Visits do

  use GenServer

  @counter_name "visits counter"

  def launch(opts) do
    timer = opts[:expire_after]
    GenServer.start(__MODULE__, timer) # Because linked to f***ing channel
  end

  # Client methods
  def count(pid) do
    GenServer.call(pid, :count)
  end

  def ping(pid, user_id) do
    GenServer.cast(pid, {:ping, user_id})
  end

  def join(pid, listener) do
    IO.puts "New listener on visits counter : #{inspect listener}"
    GenServer.call(pid, {:add_listener, listener})
  end

  def leave(pid, listener) do
    IO.puts "Removing listener on visits counter : #{inspect listener}"
    GenServer.cast(pid, {:remove_listener, listener})
  end

  # Server callbacks
  def init(timeout) do
    IO.puts "Starting #{@counter_name} on #{inspect self} with timeout #{inspect timeout}"
    {:ok, empty_state(timeout)}
  end

  def handle_call(:count, _from, state) do
    {:reply, visitors_count(state), state}
  end

  def handle_cast({:ping, user_id}, state) do
    state = state
    # Add visitor
    |> add_visitor(user_id)
    # Reset existing timeout
    |> reset_timeout(user_id)
    # Broadcast changes
    |> broadcast_changes

    IO.puts "[Visits counter ping] count is #{visitors_count(state)}"

    {:noreply, state}
  end

  def handle_cast({:unping, user_id}, state) do
    state = state
    # Remove visitor
    |> remove_visitor(user_id)
    # Broadcast changes
    |> broadcast_changes

    IO.puts "[Visits counter unping] count is #{visitors_count(state)}"

    {:noreply, state}
  end

  def handle_call({:add_listener, listener_pid}, _from, state) do
    IO.puts "[Visits counter add_listener]"
    state = state |> add_listener(listener_pid)
    response = visitors_count(state)

    {:reply, response, state}
  end

  def handle_cast({:remove_listener, listener_pid}, state) do
    state = state |> remove_listener(listener_pid)

    IO.puts "[Visits counter remove_listener]"

    {:noreply, state}
  end

  # State handling
  defp empty_state(timeout) do
    %{
      visitors: HashSet.new,
      listeners: HashSet.new,
      timeouts: HashDict.new,
      timeout: timeout
    }
  end

  defp visitors_count(%{visitors: visitors}) do
    HashSet.size(visitors)
  end

  defp add_visitor(state = %{visitors: visitors}, visitor) do
    %{state | visitors: HashSet.put(visitors, visitor)}
  end

  defp remove_visitor(state = %{visitors: visitors}, visitor) do
    %{state | visitors: HashSet.delete(visitors, visitor)}
  end

  defp add_listener(state = %{listeners: listeners}, listener) do
    IO.puts "Adding listener #{inspect listener}"
    %{state | listeners: HashSet.put(listeners, listener)}
  end

  defp remove_listener(state = %{listeners: listeners}, listener) do
    IO.puts "Removing listener #{inspect listener}"
    %{state | listeners: HashSet.delete(listeners, listener)}
  end

  defp broadcast_changes(state = %{listeners: listeners}) do
    count = visitors_count(state)
    listeners
    |> HashSet.to_list
    |> Enum.each fn(pid) -> send(pid, {:count, count}) end
    state
  end

  defp reset_timeout(state = %{timeouts: timeouts, timeout: timeout}, user_id) do
    existing_timeout = timeouts[user_id]
    if existing_timeout do
      Process.exit existing_timeout, :kill
    end
    me = self
    new_timeout = spawn fn ->
      :timer.sleep(timeout)
      GenServer.cast(me, {:unping, user_id})
    end
    %{state | timeouts: HashDict.put(timeouts, user_id, new_timeout)}
  end
end
