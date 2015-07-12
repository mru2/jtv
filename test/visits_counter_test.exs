# defmodule Jtv.VisitsCounterTest do
#   use ExUnit.Case
#
#   alias Jtv.Counter.Visits
#
#   setup do
#     {:ok, pid} = Visits.launch(expire_after: 1000)
#     {:ok, counter: pid}
#   end
#
#   test "it should store visits", context do
#     pid = context[:counter]
#
#     count = Visits.count(pid)
#     assert 0 = count
#
#     pid |> Visits.ping(1)
#     count = Visits.count(pid)
#     assert 1 = count
#   end
#
#   test "it should not count the same visitor twice", context do
#     pid = context[:counter]
#
#     count = Visits.count(pid)
#     assert 0 = count
#
#     pid |> Visits.ping(1)
#     pid |> Visits.ping(1)
#     count = Visits.count(pid)
#     assert 1 = count
#
#     pid |> Visits.ping(2)
#     count = Visits.count(pid)
#     assert 2 = count
#   end
#
#   test "it should be able to add and notify listeners", context do
#     pid = context[:counter]
#
#     pid |> Visits.ping(1)
#     refute_receive {:count, _count}
#
#     count = pid |> Visits.join(self)
#     assert 1 = count
#
#     pid |> Visits.ping(2)
#     assert_receive {:count, 2}
#
#     :ok = pid |> Visits.leave(self)
#     pid |> Visits.ping(3)
#     refute_receive {:count, _count}
#   end
#
#   test "it should expire visits after a certain time", context do
#     pid = context[:counter]
#
#     pid |> Visits.ping(1)
#     count = pid |> Visits.count
#     assert 1 = count
#
#     :timer.sleep(600)
#
#     # Timer should be reset by subsequent pings
#     pid |> Visits.ping(1)
#     count = pid |> Visits.count
#     assert 1 = count
#
#     :timer.sleep(600)
#
#     count = pid |> Visits.count
#     assert 1 = count
#
#     count = pid |> Visits.join(self)
#     assert 1 = count
#
#     :timer.sleep(600)
#
#     count = pid |> Visits.count
#     assert 0 = count
#
#     # Listeners should have been notified
#     assert_receive {:count, 0}
#
#   end
#
# end
