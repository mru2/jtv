defmodule Jtv.HitController do
  use Jtv.Web, :controller

  plug :action

  def create(conn, params) do
    # Parse the payload
    payload = params |> Jtv.Parser.parse

    # Notify the listeners
    GenEvent.notify Jtv.EventManager, {:hit, payload}

    # Respond with a 200
    json conn, %{status: :ok}
  end

  def create(conn, _params) do
    conn
    |> put_status(422)
    |> json(%{status: :invalid_params})
  end
end
