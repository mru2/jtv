defmodule Jtv.HitController do
  use Jtv.Web, :controller

  plug :action

  def create(conn, %{"@fields" => ( params = %{"user" => user_id} )}) do
    # TODO : Handle multiple counters
    Jtv.Counters.handle({:all_visits, user_id})

    json conn, %{status: :ok}
  end

  def create(conn, _params) do
    conn
    |> put_status(422)
    |> json(%{status: :invalid_params})
  end
end
