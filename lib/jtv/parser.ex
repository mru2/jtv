# Logic for categorizing logstash events
defmodule Jtv.Parser do

  def parse(payload) do
    %{
      session_id: session_id(payload),
      user_id: user_id(payload)
    }
  end

  # Request id
  defp session_id(%{"@fields" => %{"request_id" => request_id}}), do: request_id
  defp session_id(_), do: nil

  # User id
  defp user_id(%{"@fields" => %{"user" => user_id}}), do: user_id
  defp user_id(_), do: nil

end
