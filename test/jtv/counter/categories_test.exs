defmodule Jtv.Counter.CategoriesTest do
  use ExUnit.Case

  alias Jtv.Counter.Categories

  test "it works" do

    counter = Categories.new

    # Default value
    assert [] = counter |> Categories.count

    # Adding
    counter = counter
    |> Categories.add(1, :foo)
    |> Categories.add(2, :bar)
    |> Categories.add(3, :foo)
    assert [{:foo, 2}, {:bar, 1}] = counter |> Categories.count

    # Unique keys only have one bucket
    counter = counter |> Categories.add(1, :bar)
    assert [{:bar, 2}, {:foo, 1}] = counter |> Categories.count

    # Removing
    counter = counter |> Categories.remove(1)
    assert [{:bar, 1}, {:foo, 1}] = counter |> Categories.count # Alphabetical order

  end
end
