defmodule Twitter.Clock do
  def now do
    :calendar.local_time
  end

  def yesterday do
    {date, time} = :calendar.local_time
    days = :calendar.date_to_gregorian_days(date)
    date = :calendar.gregorian_days_to_date(days - 1)
    {date, time}
  end

  def format_elapsed_time(at, now) do
    format_elapsed_time(:calendar.time_difference(at, now))
  end

  defp format_elapsed_time({0, {0, 0, 0}}), do: "just now"
  defp format_elapsed_time({0, {0, 0, 1}}), do: "1 second ago"
  defp format_elapsed_time({0, {0, 1, _}}), do: "1 minute ago"
  defp format_elapsed_time({0, {1, _, _}}), do: "1 hour ago"
  defp format_elapsed_time({0, {0, 0, n}}), do: "#{n} seconds ago"
  defp format_elapsed_time({0, {0, n, _}}), do: "#{n} minutes ago"
  defp format_elapsed_time({0, {n, _, _}}), do: "#{n} hours ago"
  defp format_elapsed_time({1, _}), do: "1 day ago"
  defp format_elapsed_time({n, _}), do: "#{n} days ago"
end
