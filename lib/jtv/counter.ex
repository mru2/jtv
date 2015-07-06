# Counter process
# Handle state persistence, watchers, and expiration
# Delegate state implementation to another module
defmodule Jtv.Counter do

  use ExActor.GenServer
  alias Jtv.Watchers

  # TODO : make start_link when supervisor implemented in counters
  # TODO : re-implement expiration
  defstart start(class, opts) do
    initial_state {class, class.new, Watchers.new}
  end

  # Add to the counter
  defcast add(key, value), state: {class, values, watchers} do
    # Increment the counter
    values = values |> class.add(key, value)

    # Notify listeners
    watchers |> Watchers.broadcast class.count(values)

    # Persist the new state
    new_state {class, values, watchers}
  end

  # Remove from the counter (called as a timeout callback)
  defcast remove(key), state: {class, values, watchers} do
    # Decrement the counter
    values = values |> class.remove(key)

    # Notify listeners
    watchers |> Watchers.broadcast class.count(values)

    # Persist the new state
    new_state {class, values, watchers}
  end

  # Add a listener, returning the current counter value
  defcall add_watcher(pid), state: {class, values, watchers} do
    # Add the watcher
    watchers = watchers |> Watchers.add pid

    # Fetch the current count
    count = values |> class.count

    # Persist the new state and returns the count
    set_and_reply {class, values, watchers}, count
  end

  # Removes a listener
  defcast remove_listener(pid), state: {class, values, watchers} do
    # Removes the watcher
    watchers = watchers |> Watchers.remove pid

    # Persist the new state
    new_state {class, values, watchers}
  end

  # TO REIMPLEMENT : timeout implementation
  # defp reset_timeout(state = %{timeouts: timeouts, timeout: timeout}, user_id) do
  #   existing_timeout = timeouts[user_id]
  #   if existing_timeout do
  #     Process.exit existing_timeout, :kill
  #   end
  #   me = self
  #   new_timeout = spawn fn ->
  #     :timer.sleep(timeout)
  #     GenServer.cast(me, {:unping, user_id})
  #   end
  #   %{state | timeouts: HashDict.put(timeouts, user_id, new_timeout)}
  # end

end
