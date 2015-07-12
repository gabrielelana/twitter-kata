defmodule Twitter.MessageTest do
  use ExUnit.Case
  alias Twitter.Message

  test "format elapsed time" do
    {date, time} = :calendar.local_time

    assert Message.format_elapsed_time({date, time}, {date, time}) == "just now"

    assert Message.format_elapsed_time({date, {0, 1, 0}}, {date, {0, 1, 1}}) == "1 second ago"
    assert Message.format_elapsed_time({date, {0, 0, 59}}, {date, {0, 1, 0}}) == "1 second ago"
    assert Message.format_elapsed_time({date, {0, 1, 0}}, {date, {0, 1, 42}}) == "42 seconds ago"
    assert Message.format_elapsed_time({date, {0, 1, 0}}, {date, {0, 2, 0}}) == "1 minute ago"
    assert Message.format_elapsed_time({date, {0, 1, 0}}, {date, {0, 4, 0}}) == "3 minutes ago"
    assert Message.format_elapsed_time({date, {1, 0, 0}}, {date, {2, 0, 0}}) == "1 hour ago"
    assert Message.format_elapsed_time({date, {1, 0, 0}}, {date, {4, 0, 0}}) == "3 hours ago"

    assert Message.format_elapsed_time({{2015, 7, 11}, time}, {{2015, 7, 12}, time}) == "1 day ago"
    assert Message.format_elapsed_time({{2015, 7, 1}, time}, {{2015, 7, 12}, time}) == "11 days ago"
    assert Message.format_elapsed_time({{2015, 3, 1}, time}, {{2015, 7, 12}, time}) == "133 days ago"
  end

  test "format" do
    {date, _} = :calendar.local_time
    message = %Message{at: {date, {10, 0, 0}}, from: "Alice", text: "Programming is fun!"}
    assert Message.format(message, {date, {10, 3, 0}}) == "Programming is fun! (3 minutes ago)"
  end

  test "format for the wall" do
    {date, _} = :calendar.local_time
    message = %Message{at: {date, {10, 0, 0}}, from: "Alice", text: "Programming is fun!"}
    assert Message.format_for_wall(message, {date, {10, 3, 0}}) == "Alice - Programming is fun! (3 minutes ago)"
  end
end
