# Logic for categorizing logstash events
defmodule Jtv.Parser do

  def parse(payload) do
    %{
      user_id: user_id(payload),
      school: school(payload),
      page: page(payload)
    }
  end

  # User id
  defp user_id(%{"@fields" => %{"user" => user_id}}), do: user_id
  defp user_id(_), do: nil

  # Current school
  defp school(%{"@fields" => %{"school" => permalink}}), do: permalink |> String.to_atom
  defp school(_), do: nil

  # Current page
  defp page(%{"@fields" => %{"controller" => controller, "action" => action, "path" => path}}) do
    case {controller, action, path} do
      # Ignored hits
      {"colors", "show", _} -> nil
      {"errors", _, _} -> nil
      {nil, nil, _} -> nil
      {_, "autocomplete" <> _, _} -> nil
      {"school_widgets", _, _} -> nil
      {"companies", "more_news", _} -> nil
      {"search", "index", _} -> nil
      {"search", "search", _} -> nil
      {"student_profiles", "update", _} -> nil
      {"application", "get_generic_position_for_select", _} -> nil
      {"locations", "update_map", _} -> nil
      {"companies", "like", _} -> nil
      {"companies", "unlike", _} -> nil


      # Landings
      {"home", "index", _} -> :homepage
      {"dashboards", _, _} -> :dashboard
      {"student_profiles", "show", _} -> :auth
      {"student_profiles", "edit", _} -> :auth

      # Job offers
      {"job_offers", "add_to_cart", _} -> :job_offer_add_to_cart
      {"job_offers", "remove_from_cart", _} -> nil
      {"user_actions", "job_offer_application", _} -> :job_offer_application
      {"job_offers", "apply", _} -> :job_offer_application
      {"job_offers", "index", "/fr/entreprises/" <> _} -> :company_job_offers
      {"job_offers", "index", _} -> :job_offer_search
      {"job_offers", "show", _} -> :job_offer

      # Companies
      {"company_categories", "show", _} -> :company
      {"companies", "index", _} -> :company

      {"companies", "show", _} -> :company
      {"companies", "recruitment", _} -> :company
      {"companies", "activity", _} -> :company
      {"companies", "happy_trainees", _} -> :company
      {"positions", _, _} -> :company
      {"posts", _, _} -> :company
      {"locations", _, _} -> :company

      # Events
      {"events", _, _} -> :events

      # Articles
      {"articles", _, _} -> :articles

      # Positions
      {"position_categories", "show", _} -> :positions
      {"generic_positions", _, _} -> :positions

      # Advices
      {"advice_categories", _, _} -> :advices
      {"advices", _, _} -> :advices

      # Backend / API
      {"backend/" <> _, _, _} -> :backend
      {"sp_companies/" <> _, _, _} -> :backend
      {"sp_job_offers/" <> _, _, _} -> :backend
      {"recruitment/" <> _, _, _} -> :backend
      {"api/" <> _, _, _} -> :api

      # Login / Signup
      {"users", "sso_activation", _} -> :auth
      {"student_profiles", "update_from_sso", _} -> :auth
      {"users/" <> _, _, _} -> :auth
      {"custom_devise/" <> _, _, _} -> :auth
      {"student_profiles", "new", _} -> :auth
      {"student_profiles", "create", _} -> :auth

      # Other
      {"press", _, _} -> :other
      {"static_pages", _, _} -> :other
      {"schools", "index", _} -> :other
      {"ambassadeurs", "index", _} -> :other

      # Last catchall
      {"users", _, _} -> nil
      {"student_profiles", _, _} -> nil
      {"sharing_mail", _, _} -> nil
      {_, "share", _} -> nil

      _ ->
        IO.puts "No match for #{inspect {controller, action, path}}"
        :other
    end
  end

  defp page(_), do: nil

end
