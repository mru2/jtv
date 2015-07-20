defmodule Jtv.Timeout do

  # Key-value store of timeouts, since we can't name processes with tuples ...
  def start_link do
    Agent.start_link(fn -> Map.new end, name: __MODULE__)
  end

  def spawn(key, function, timeout) do
    # Cancel any existing timeout
    cancel(key)

    # Starts the timeout
    pid = spawn fn ->
      :timer.sleep(timeout)
      function.()
    end

    # Stores the pid
    Agent.update __MODULE__, fn map -> Map.put(map, key, pid) end
  end

  def cancel(key) do
    # Finds the pid
    pid = Agent.get_and_update __MODULE__, fn map -> Map.pop(map, key) end

    # Kills the process
    if pid && Process.alive?(pid) do
      Process.exit pid, :kill
    end
  end

end
