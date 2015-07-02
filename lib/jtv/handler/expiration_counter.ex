# Another event handler
defmodule Jtv.Handler.ExpirationCounter do
  use GenEvent

  def init(_args) do
    {:ok, 0}
  end

  def handle_event({:hit, _params}, count) do
    IO.puts "Got expiration hit"
    Jtv.Counter.Views.ping 1
    Jtv.Counter.Visits.ping 1
    {:ok, count + 1}
  end

  def handle_call(:count, count) do
    {:ok, count}
  end
end
