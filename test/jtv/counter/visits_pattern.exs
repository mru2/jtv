defmodule Jtv.Counter.VisitsPatternTest do
  use ExUnit.Case

  alias Jtv.Counter.VisitsPattern

  test "it works" do

    counter = VisitsPattern.new

    # Default value
    assert [] = counter |> VisitsPattern.count

    # Adding
    counter = counter
    |> VisitsPattern.add(1, :job_offer_index)
    |> VisitsPattern.add(1, :job_offer_show)
    |> VisitsPattern.add(1, :job_offer_apply)
    |> VisitsPattern.add(1, :job_offer_show)
    |> VisitsPattern.add(1, :company_show)
    |> VisitsPattern.add(1, :company_job_offers)

    |> VisitsPattern.add(2, :company_show)
    |> VisitsPattern.add(2, :company_job_offers)
    |> VisitsPattern.add(2, :job_offer_show)
    |> VisitsPattern.add(2, :company_show)

    |> VisitsPattern.add(3, :dashboard_show)
    |> VisitsPattern.add(3, :job_offer_show)
    |> VisitsPattern.add(3, :job_offer_apply)
    |> VisitsPattern.add(3, :job_offer_show)
    |> VisitsPattern.add(3, :company_show)
    |> VisitsPattern.add(3, :company_job_offers)
    |> VisitsPattern.add(3, :job_offer_show)

    # Extract frequent patterns
    assert [
      {:job_offer_show, :job_offer_apply, :job_offer_show},
      {:job_offer_apply, :job_offer_show, :company_show},
      {:company_show, :company_job_offers, :job_offer_show},
      {:job_offer_show, :company_show, :company_job_offers}
    ] = ( counter |> VisitsPattern.count )

    # Drop a session
    counter = counter |> VisitsPattern.remove(1)

    # New top patterns without the last session
    assert [
      {:company_show, :company_job_offers, :job_offer_show}
    ] = ( counter |> VisitsPattern.count )

    #
    # # Unique keys only have one bucket
    # counter = counter |> Categories.add(1, :bar)
    # assert [{:bar, 2}, {:foo, 1}] = counter |> Categories.count
    #
    # # Removing
    # counter = counter |> Categories.remove(1)
    # assert [{:bar, 1}, {:foo, 1}] = counter |> Categories.count # Alphabetical order

  end
end
