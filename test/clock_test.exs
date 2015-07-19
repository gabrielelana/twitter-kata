defmodule Twitter.ClockTest do
  use ExUnit.Case
  alias Twitter.Clock

  test "format elapsed time" do
    {date, time} = Clock.now

    assert Clock.format_elapsed_time({date, time}, {date, time}) == "just now"

    assert Clock.format_elapsed_time({date, {0, 1, 0}}, {date, {0, 1, 1}}) == "1 second ago"
    assert Clock.format_elapsed_time({date, {0, 0, 59}}, {date, {0, 1, 0}}) == "1 second ago"
    assert Clock.format_elapsed_time({date, {0, 1, 0}}, {date, {0, 1, 42}}) == "42 seconds ago"
    assert Clock.format_elapsed_time({date, {0, 1, 0}}, {date, {0, 2, 0}}) == "1 minute ago"
    assert Clock.format_elapsed_time({date, {0, 1, 0}}, {date, {0, 4, 0}}) == "3 minutes ago"
    assert Clock.format_elapsed_time({date, {1, 0, 0}}, {date, {2, 0, 0}}) == "1 hour ago"
    assert Clock.format_elapsed_time({date, {1, 0, 0}}, {date, {4, 0, 0}}) == "3 hours ago"

    assert Clock.format_elapsed_time({{2015, 7, 11}, time}, {{2015, 7, 12}, time}) == "1 day ago"
    assert Clock.format_elapsed_time({{2015, 7, 1}, time}, {{2015, 7, 12}, time}) == "11 days ago"
    assert Clock.format_elapsed_time({{2015, 3, 1}, time}, {{2015, 7, 12}, time}) == "133 days ago"
  end
end
