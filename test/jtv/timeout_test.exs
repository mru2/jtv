defmodule Jtv.Counter.ParserTest do
  use ExUnit.Case

  alias Jtv.Timeout

  setup do
    Timeout.start_link
    :ok
  end

  test "spawn" do
    me = self
    Timeout.spawn(:foo, fn -> send(me, :msg) end, 100)
    refute_received :msg
    :timer.sleep(120)
    assert_received :msg
  end

  test "cancel" do
    me = self
    Timeout.spawn(:foo, fn -> send(me, :msg) end, 100)
    Timeout.cancel(:foo)
    :timer.sleep(120)
    refute_received :msg
  end

  test "refreshing" do
    me = self
    Timeout.spawn(:foo, fn -> send(me, :msg) end, 100)
    :timer.sleep(60)
    refute_received :msg
    Timeout.spawn(:foo, fn -> send(me, :msg) end, 100)
    :timer.sleep(60)
    refute_received :msg
    :timer.sleep(60)
    assert_received :msg
  end

end
