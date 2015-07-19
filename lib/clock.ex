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


  def at({h, m, s}) do
    {date, _} = now
    {date, {h, m, s}}
  end

  def at(clock, {:after, n, units}) do
    :calendar.gregorian_seconds_to_datetime(seconds_in(clock) + seconds_in(n, units))
  end
  def at(clock, {:before, n, units}) do
    :calendar.gregorian_seconds_to_datetime(seconds_in(clock) - seconds_in(n, units))
  end

  defp seconds_in(datetime), do: :calendar.datetime_to_gregorian_seconds(datetime)

  defp seconds_in(n, :second), do: n
  defp seconds_in(n, :secondss), do: n
  defp seconds_in(n, :minute), do: n * 60
  defp seconds_in(n, :minutes), do: n * 60
  defp seconds_in(n, :hour), do: n * 3600
  defp seconds_in(n, :hours), do: n * 3600
  defp seconds_in(n, :day), do: n * 86400
  defp seconds_in(n, :days), do: n * 86400
end
