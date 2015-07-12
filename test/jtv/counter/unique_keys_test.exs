defmodule Jtv.Counter.UniqueKeysTest do
  use ExUnit.Case

  alias Jtv.Counter.UniqueKeys

  test "it works" do
    counter = UniqueKeys.new

    # Default value
    assert 0 = counter |> UniqueKeys.count

    # Adding, return value
    counter = counter |> UniqueKeys.add :foo, nil
    assert 1 = counter |> UniqueKeys.count

    # Unique keys counted once
    counter = counter
    |> UniqueKeys.add(:bar, nil)
    |> UniqueKeys.add(:foo, nil)
    assert 2 = counter |> UniqueKeys.count

    # Removing
    counter = counter |> UniqueKeys.remove :foo
    assert 1 = counter |> UniqueKeys.count

  end
end
