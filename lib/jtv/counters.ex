# Wrapper around a process dictionary for each counter
# Allow dynamic creation and subscribing
defmodule Jtv.Counters do

  # Counter dictionary : HashDict of key => pid
  def start_link(opts \\ []) do
    Agent.start_link(fn -> HashDict.new end, name: __MODULE__)
  end

  # Get a counter pid by key
  def get(counter) do
    pid = Agent.get(__MODULE__, fn dict -> HashDict.get(dict, counter) end)

    # Dynamically launch the counter process if none yet
    cond do
      !pid -> launch(counter)
      true -> pid
    end
  end

  # Lauch a counter by key, return its pid
  def launch(counter) do
    {mod, opts} = counter_type(counter)
    {:ok, pid} = Jtv.Counter.start(mod, opts)

    # TODO : supervise counter properly
    Agent.update(__MODULE__, &(HashDict.put(&1, counter, pid)))

    pid
  end

  # Counter types
  # TODO : also handle lambda for pattern matching signals
  def counter_type({:all_visits, []}) do
    { Jtv.Counter.UniqueKeys, [expire_after: 5 * 60 * 1000] }
  end

end
