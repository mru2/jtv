defmodule Jtv.Counter.ParserTest do
  use ExUnit.Case

  alias Jtv.Parser

  def result(json), do: json |> Poison.decode! |> Parser.parse

  test "it should extract the user id" do
    assert %{user_id: 318707} = result(~s({"@source":"jobteaser_logger","@tags":["request"],"@fields":{"method":"GET","path":"/users/auth/tbs_cas/callback","format":"html","controller":"users/omniauth_callbacks","action":"tbs_cas","status":302,"duration":585.6,"db":532.51,"location":"http://tbs.jobteaser.com/","ip":"109.215.242.167","route":"users/omniauth_callbacks#tbs_cas","request_id":"37c7c31e5d6740f89ea23e533fb66b05","user":318707,"school":"tbs"},"@timestamp":"2015-07-01T04:25:39.461578+00:00"}))
    assert %{user_id: nil} = result(~s({"@source":"jobteaser_logger","@tags":["request"],"@fields":{"method":"GET","path":"/fr/entreprises/thales/offres-emploi-stage/645675-support-controleur-de-gestion-programme-en-alternance-h-f","format":"html","controller":"job_offers","action":"show","status":200,"duration":302.54,"view":241.36,"db":46.13,"ip":"62.210.151.90","route":"job_offers#show","request_id":"ca7a52c5d65f204f985200a34bec9ea2","company":"thales"},"@timestamp":"2015-07-01T04:25:36.981950+00:00"}))
  end

  test "it should extract the school" do
    assert %{school: :tbs} = result(~s({"@source":"jobteaser_logger","@tags":["request"],"@fields":{"method":"GET","path":"/","format":"html","controller":"home","action":"index","status":302,"duration":5.59,"db":1.26,"location":"http://tbs.jobteaser.com/users/auth/tbs_cas","ip":"109.215.242.167","route":"home#index","request_id":"4370070faa0a3854ef260f4736aa12c9","school":"tbs"},"@timestamp":"2015-07-01T04:25:38.191272+00:00"}))
    assert %{school: nil} = result(~s({"@source":"jobteaser_logger","@tags":["request"],"@fields":{"method":"GET","path":"/fr/entreprises/thales/offres-emploi-stage/645675-support-controleur-de-gestion-programme-en-alternance-h-f","format":"html","controller":"job_offers","action":"show","status":200,"duration":302.54,"view":241.36,"db":46.13,"ip":"62.210.151.90","route":"job_offers#show","request_id":"ca7a52c5d65f204f985200a34bec9ea2","company":"thales"},"@timestamp":"2015-07-01T04:25:36.981950+00:00"}))
  end

  test "it should extract the page category" do
    assert %{page: :job_offer} = result(~s({"@source":"jobteaser_logger","@tags":["request"],"@fields":{"method":"GET","path":"/fr/entreprises/thales/offres-emploi-stage/645675-support-controleur-de-gestion-programme-en-alternance-h-f","format":"html","controller":"job_offers","action":"show","status":200,"duration":302.54,"view":241.36,"db":46.13,"ip":"62.210.151.90","route":"job_offers#show","request_id":"ca7a52c5d65f204f985200a34bec9ea2","company":"thales"},"@timestamp":"2015-07-01T04:25:36.981950+00:00"}))
    assert %{page: :homepage} = result(~s({"@source":"jobteaser_logger","@tags":["request"],"@fields":{"method":"GET","path":"/","format":"html","controller":"home","action":"index","status":302,"duration":5.59,"db":1.26,"location":"http://tbs.jobteaser.com/users/auth/tbs_cas","ip":"109.215.242.167","route":"home#index","request_id":"4370070faa0a3854ef260f4736aa12c9","school":"tbs"},"@timestamp":"2015-07-01T04:25:38.191272+00:00"}))
  end


end
