defmodule Jtv.StatsChannel do
  use Phoenix.Channel

  # Listen to a given counter, launching it if needed
  def join("stats:" <> name, params, socket) do
    # Get counter key from name and params
    counter_key = { String.to_atom(name), [] }

    # Persist the counter key in order to kill the watcher on socket termination
    socket = socket |> assign :counter_key, counter_key

    # Watch counter updates
    {:value, val} = counter_key
    |> Jtv.Counters.get
    |> Jtv.Counter.add_watcher

    # Create handle if needed
    {:ok, %{val: val}, socket}
  end

  # Proxy counter updates to the client
  def handle_info({:new_value, val}, socket) do
    push socket, "new_val", %{val: val}

    {:noreply, socket}
  end


  def terminate(reason, socket) do
    # Drop watcher
    socket.assign(:counter_key)
    |> Jtv.Counters.get
    |> Jtv.Counter.remove_watcher

    {:shutdown}
  end

end
