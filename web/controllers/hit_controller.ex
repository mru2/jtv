defmodule Jtv.HitController do
  use Jtv.Web, :controller

  plug :action

  def create(conn, %{"hit" => params}) do
    GenEvent.notify Jtv.EventManager, {:hit, params}
    json conn, %{status: :ok}
  end

  def create(conn, _params) do
    conn
    |> put_status(422)
    |> json(%{status: :invalid_params})
  end
end
