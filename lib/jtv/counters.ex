# Wrapper around a process dictionary for each counter
# Allow dynamic creation and subscribing
defmodule Jtv.Counters do

  # Counter dictionary : Map of key => pid
  def start_link(opts \\ []) do
    Agent.start_link(fn -> Map.new end, name: __MODULE__)
  end

  # Get a counter pid by key
  def get(counter) do
    pid = Agent.get(__MODULE__, fn dict -> Map.get(dict, counter) end)

    # Dynamically launch the counter process if none yet
    cond do
      !pid -> launch(counter)
      true -> pid
    end
  end

  # Lauch a counter by key, return its pid
  def launch(counter) do
    {counter_type, filter, expiration} = counter_opts(counter)

    # Launch counter process
    {:ok, pid} = Jtv.Counter.start(counter_type, [expiration: expiration])

    # Make it monitor the hits
    GenEvent.add_handler Jtv.EventManager, Jtv.Filter, [counter: pid, filter: filter]

    # TODO : supervise counter properly
    Agent.update(__MODULE__, &(Map.put(&1, counter, pid)))

    pid
  end

  # Todo : handle termination of counters

  # Counter types
  # Returns a map with the following info
  # - counter type
  # - counter args
  # - filter type
  def counter_opts({:all_visits, []}) do
    { Jtv.Counter.UniqueKeys, &Jtv.Filter.unique_users/1, 5 * 60 * 1000 }
  end

end
