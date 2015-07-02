# Not needed anymore I think
defmodule Jtv.Messages do

  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def push(message) do
    Agent.update(__MODULE__, &([message | &1]))
    Jtv.Endpoint.broadcast! "stats:flux", "new_msg", %{body: message}
    {:ok, message}
  end

  def all do
    Agent.get(__MODULE__, &(&1))
  end

end
