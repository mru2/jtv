defmodule Jtv.Counter.VisitsPattern do
  require IEx

  def new do
    %{sessions: HashDict.new, patterns: HashDict.new}
  end

  def add(counter = %{sessions: sessions, patterns: patterns}, session_id, page) do
    # Store the page view, get the matching triplet if any
    {sessions, triplet} = sessions |> add_page_view(session_id, page)
    counter = %{counter | sessions: sessions}

    case triplet do
      nil -> counter
      triplet ->
        patterns = patterns |> add_triplet(triplet)
        %{counter | patterns: patterns}
    end
  end

  # Returns the top triplets with at least 1 visit
  def count(%{patterns: patterns}) do
    patterns
    |> Enum.filter( fn {_triplet, count} -> count > 1 end )
    |> Enum.sort_by( fn {_triplet, count} -> - count end )
    |> Enum.map( fn {triplet, _count} -> triplet end )
  end

  def remove(%{sessions: sessions, patterns: patterns}, session_id) do
    # Remove the session history
    {history, sessions} = sessions |> HashDict.pop(session_id, [])

    # Extract triplets from history, and decount them from the patterns
    triplets = history |> extract_triplets
    patterns = patterns |> remove_triplets(triplets)

    %{sessions: sessions, patterns: patterns}
  end

  # Private methods

  defp add_page_view(sessions, session_id, page) do
    # Get existing history
    history = sessions |> HashDict.get(session_id, [])

    # Generate the triplet of the 3 last page views
    # TODO? Handle larger n-plets (4, 5, ...) ?
    triplet = case history do
      [last | [former | _others]] -> {former, last, page}
      _ -> nil
    end

    # Update the session history
    sessions = sessions |> HashDict.put(session_id, [page | history])

    {sessions, triplet}
  end

  defp add_triplet(triplets, triplet) do
    # Increment the triplets counter, starting at 0 if none
    triplets
    |> HashDict.update(triplet, 1, fn counter -> counter + 1 end)
  end

  # Extract triplets from an history
  defp extract_triplets(history), do: extract_triplets(history, [])
  defp extract_triplets([page3 | [page2 | [page1 | rest]]], triplets), do: extract_triplets([page2 | [page1 | rest]], [{page1, page2, page3} | triplets])
  defp extract_triplets(_, triplets), do: triplets

  # Remove triplets from the patterns
  defp remove_triplets(patterns, []), do: patterns
  defp remove_triplets(patterns, [triplet | rest]) do
    # Unping the triplet
    patterns = case ( patterns |> HashDict.get(triplet) ) do
      nil    -> patterns
      1      -> HashDict.delete(patterns, triplet)
      count  -> HashDict.put(patterns, triplet, (count - 1))
    end

    # Recursively drop the others
    remove_triplets(patterns, rest)
  end

end
