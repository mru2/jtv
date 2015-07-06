defmodule Jtv.HitController do
  use Jtv.Web, :controller

  plug :action

  def create(conn, %{"@fields" => ( params = %{"user" => user_id} )}) do

    # TODO : Handle multiple counters
    {:all_visits, []}
    |> Jtv.Counters.get
    |> Jtv.Counter.add user_id, user_id

    json conn, %{status: :ok}
  end

  def create(conn, _params) do
    conn
    |> put_status(422)
    |> json(%{status: :invalid_params})
  end
end
