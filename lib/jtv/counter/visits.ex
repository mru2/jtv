defmodule Jtv.Counter.Visits do
  def start_link(opts \\ []) do
    IO.puts "Starting link"
    {:ok, self, opts}
  end

  def ping(user_id) do
    :ping
  end
end
