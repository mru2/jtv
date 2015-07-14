# Handle filtering / parsing payloads for counters
# Also double as an event handler because why not
defmodule Jtv.Filter do

  # GenEvent handler callbacks
  def init(args) do
    {:ok, {args[:counter], args[:filter]}}
  end

  def handle_event({:hit, payload}, {counter, filter}) do
    case filter.(payload) do
      nil -> true # Nothing
      {key, value} -> counter |> Jtv.Counter.add(key, value)
    end

    {:ok, {counter, filter}}
  end


  # Filter methods, returns either nil or a {key, value} tuple, for a given payload

  # Filter logged users, returning their ID
  def unique_users(%{user_id: user_id}), do: {user_id, user_id}
  def unique_users(_), do: nil

end
