defmodule Twitter.Message do
  alias Twitter.Message

  defstruct at: nil, from: "", text: ""

  def format_for_wall(%Message{from: from} = message, now) do
    "#{from} - #{format(message, now)}"
  end

  def format(%Message{at: at, text: text}, now) do
    "#{text} (#{format_elapsed_time(at, now)})"
  end

  def format_elapsed_time(at, now) do
    format_elapsed_time(:calendar.time_difference(at, now))
  end

  defp format_elapsed_time({0, {0, 0, 1}}), do: "1 second ago"
  defp format_elapsed_time({0, {0, 1, _}}), do: "1 minute ago"
  defp format_elapsed_time({0, {1, _, _}}), do: "1 hour ago"
  defp format_elapsed_time({0, {0, 0, n}}), do: "#{n} seconds ago"
  defp format_elapsed_time({0, {0, n, _}}), do: "#{n} minutes ago"
  defp format_elapsed_time({0, {n, _, _}}), do: "#{n} hours ago"
  defp format_elapsed_time({1, _}), do: "1 day ago"
  defp format_elapsed_time({n, _}), do: "#{n} days ago"
end
