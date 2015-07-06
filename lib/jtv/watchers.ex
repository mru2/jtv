# Utilities for watchers manipulation and broadcast
# TODO : dig a little deeper, this must be part of OTP already
defmodule Jtv.Watchers do

  def new, do: HashSet.new

  def add(watchers, pid), do: HashSet.put(watchers, pid)

  def remove(watchers, pid), do: HashSet.delete(watchers, pid)

  def broadcast(watchers, value) do
    watchers
    |> HashSet.to_list
    |> Enum.each fn(pid) -> send(pid, value) end
  end

end
