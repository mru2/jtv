defmodule Jtv.Counter.UniqueKeys do

  # TODO : returns whether the count changed on add

  def new(opts \\ []), do: HashSet.new

  def add(counter, key, _value), do: counter |> HashSet.put(key)

  def remove(counter, key), do: counter |> HashSet.delete(key)

  def count(counter), do: counter |> HashSet.size

end
