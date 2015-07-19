defmodule Twitter.MessageTest do
  use ExUnit.Case
  alias Twitter.Message
  alias Twitter.Clock

  test "format" do
    a_time = Clock.now
    after_3_minutes = Clock.at(a_time, {:after, 3, :minutes})
    message = %Message{at: a_time, from: "Alice", text: "Programming is fun!"}
    assert Message.format(message, after_3_minutes) == "Programming is fun! (3 minutes ago)"
  end

  test "format for the wall" do
    a_time = Clock.now
    after_3_minutes = Clock.at(a_time, {:after, 3, :minutes})
    message = %Message{at: a_time, from: "Alice", text: "Programming is fun!"}
    assert Message.format_for_wall(message, after_3_minutes) == "Alice - Programming is fun! (3 minutes ago)"
  end
end
