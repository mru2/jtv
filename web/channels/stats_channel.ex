defmodule Jtv.StatsChannel do
  use Phoenix.Channel

  # Can't find how to listen to the socket mailbox, use a proxy instead
  # defmodule Proxy do
  #   require IEx
  #   def proxy(socket) do
  #     receive do
  #       {:count, value} ->
  #         IO.puts "[Proxy] got #{value}"
  #         IEx.pry
  #         Phoenix.Channel.push(socket, "new_val", %{val: value})
  #         IO.puts "[Proxy] sent"
  #         proxy(socket)
  #     end
  #   end
  # end

  # Visits on all pages
  def join("stats:all_visits", auth_msg, socket) do
    IO.puts "Joined all visits channel on #{inspect self} with #{inspect auth_msg}"

    # proxy = spawn_link(Proxy, :proxy, [socket])
    # socket = assign(socket, :proxy, proxy)
    # IO.puts "Initialized proxy : #{inspect proxy}"

    count = Jtv.Counters.listen(:all_visits, self)
    IO.puts "Got a count for all visits : #{count}"

    # Create handle if needed
    {:ok, %{val: count}, socket}
  end

  # Visits on specific page
  def join("stats:page_visits", _auth_msg, socket) do
    # IO.puts "Joined page visits channel : #{IO.inspect self}"
    #
    # # Create handle if needed
    # {:ok, %{body: Jtv.Messages.all}, socket}
  end

  # Message proxying
  def handle_info({:count, value}, socket) do
    IO.puts "[SOCKET] got new value"
    push socket, "new_val", %{val: value}
    {:noreply, socket}
  end


  def terminate(reason, socket) do
    IO.puts "Leaving channel"

    proxy = socket.assigns[:proxy]
    IO.puts "Killing proxy #{inspect proxy}"

    # Drop listener
    Jtv.Counters.leave(:all_visits, proxy)

    IO.puts "Proxy killed, dropping now"
    {:shutdown}
  end

  # Default implementation
  # def handle_out("new_msg", payload, socket) do
  #   push socket, "new_msg", payload
  #   {:noreply, socket}
  # end
end
