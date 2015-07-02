defmodule Jtv.StatsChannel do
  use Phoenix.Channel

  def join("stats:flux", _auth_msg, socket) do
    {:ok, %{body: Jtv.Messages.all}, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    {:ok, msg} = Jtv.Messages.push(body)
    {:noreply, socket}
  end

  # Default implementation
  # def handle_out("new_msg", payload, socket) do
  #   push socket, "new_msg", payload
  #   {:noreply, socket}
  # end
end
