defmodule Jtv.PageController do
  use Jtv.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
