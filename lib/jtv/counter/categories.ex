defmodule Jtv.Counter.Categories do

  # Internally, Map of key => category
  # May ne optimized with a better data structure
  def new do
    Map.new
  end

  def add(counter, key, category) do
    counter |> Map.put(key, category)
  end

  def remove(counter, key) do
    counter |> Map.delete(key)
  end

  def count(counter) do
    counter
    |> Enum.group_by( fn {_key, category} -> category end )
    |> Enum.map( fn {key, groups} -> {key, Enum.count(groups)} end )
    |> Enum.sort_by( fn {key, count} -> {-count, key} end )
  end

end
