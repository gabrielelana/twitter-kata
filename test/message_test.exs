defmodule Twitter.MessageTest do
  use ExUnit.Case
  alias Twitter.Message
  alias Twitter.Clock

  test "format" do
    {date, _} = Clock.now
    message = %Message{at: {date, {10, 0, 0}}, from: "Alice", text: "Programming is fun!"}
    assert Message.format(message, {date, {10, 3, 0}}) == "Programming is fun! (3 minutes ago)"
  end

  test "format for the wall" do
    {date, _} = Clock.now
    message = %Message{at: {date, {10, 0, 0}}, from: "Alice", text: "Programming is fun!"}
    assert Message.format_for_wall(message, {date, {10, 3, 0}}) == "Alice - Programming is fun! (3 minutes ago)"
  end
end
