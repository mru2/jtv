# Wrapper around a process dictionary for each counter
# Allow dynamic creation and subscribing
defmodule Jtv.Counters do

  def start_link(opts \\ []) do
    Agent.start_link(fn -> HashDict.new end, name: __MODULE__)
  end

  # TODO : allow passing metadata
  def handle({counter_name, key}) do
    counter_name
    |> get_counter_pid
    |> send_hit(key)
  end

  def listen(counter_name, pid) do
    counter_name
    |> get_counter_pid
    |> add_listener(pid)
  end

  def leave(counter_name, pid) do
    counter_name
    |> get_counter_pid
    |> remove_listener(pid)
  end

  def get_pid(counter_name) do
    IO.puts "Getting PID for #{counter_name}"
    pid = Agent.get(__MODULE__, &(HashDict.get(&1, counter_name)))
    cond do
      !pid ->
        IO.puts "No pid found"
        nil
      !Process.alive?(pid) ->
        IO.puts "PID found (#{inspect pid}) but is dead"
        nil
      true ->
        pid
    end
  end

  defp get_counter_pid(counter_name) do
    IO.puts "Getting counter pid for #{counter_name}"
    pid = get_pid(counter_name)

    # Launch if missing
    if !pid do
      IO.puts "PID not found, launching it"
      {:ok, pid} = launch_counter(counter_name)
      Agent.update(__MODULE__, &(HashDict.put(&1, counter_name, pid)))
      IO.puts "PID is #{inspect pid}"
    else
      IO.puts "PID found : #{inspect pid}"
    end

    pid
  end

  defp launch_counter(counter_name) do
    # TODO : handle other counter types. Also SUPERVISE them.
    Jtv.Counter.Visits.launch(expire_after: 5 * 60 * 1000)
  end

  defp send_hit(counter, key) do
    Jtv.Counter.Visits.ping counter, key
  end

  defp add_listener(counter, pid) do
    IO.puts "Adding listener on #{inspect counter} : #{inspect pid}"
    Jtv.Counter.Visits.join counter, pid
  end

  defp remove_listener(counter, pid) do
    IO.puts "Removing listener on #{inspect counter} : #{inspect pid}"
    Jtv.Counter.Visits.leave counter, pid
  end

end
