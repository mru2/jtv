# Wrapper around a process dictionary for each counter
# Allow dynamic creation and subscribing
defmodule Jtv.Counters do

  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    children = [
      # Counter dictionary : Map of key => pid
      # Couldn't find how to do it via the supervisor ...
      worker(Agent, [fn -> Map.new end, [name: Jtv.Counters.List]], restart: :permanent)
    ]

    supervise(children, strategy: :one_for_one)
  end

  # Get a counter pid by key
  def get(counter) do
    pid = Agent.get(Jtv.Counters.List, fn dict -> Map.get(dict, counter) end)

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
    {:ok, pid} = Supervisor.start_child(__MODULE__, worker(
      Jtv.Counter,
      [counter_type, [expiration: expiration]],
      restart: :transient
    ))

    # Make it monitor the hits
    GenEvent.add_handler Jtv.EventManager, Jtv.Filter, [counter: pid, filter: filter]

    # Save the pid
    Agent.update(Jtv.Counters.List, &(Map.put(&1, counter, pid)))

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
