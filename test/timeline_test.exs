defmodule Twitter.TimelineTest do
  use ExUnit.Case
  alias Twitter.Timeline
  alias Twitter.Message
  alias Twitter.Clock

  test "push single message" do
    message = %Message{at: Clock.now, from: "Alice", text: "Busy at work"}
    timeline = Timeline.new |> Timeline.push(message)

    assert Timeline.wall(timeline) == [message]
  end

  test "push messages from multile users" do
    message_from_alice = %Message{from: "Alice", text: "Busy at work"}
    message_from_bob = %Message{from: "Bob", text: "Time flies!"}
    timeline = Timeline.new
               |> Timeline.push(message_from_alice)
               |> Timeline.push(message_from_bob)

    assert message_from_alice in Timeline.wall(timeline)
    assert message_from_bob in Timeline.wall(timeline)
  end

  test "filter messages from a user" do
    message_from_alice = %Message{from: "Alice", text: "Busy at work"}
    message_from_bob = %Message{from: "Bob", text: "Time flies!"}
    timeline = Timeline.new
               |> Timeline.push(message_from_alice)
               |> Timeline.push(message_from_bob)

    assert message_from_alice in Timeline.from(timeline, "Alice")
    refute message_from_bob in Timeline.from(timeline, "Alice")
  end

  test "filter messages from the future" do
    a_time = Clock.now
    after_1_hour = Clock.at(a_time, {:after, 1, :hour})
    message_from_the_past = %Message{at: a_time, from: "Alice", text: "Busy at work"}
    message_from_the_future = %Message{at: after_1_hour, from: "Alice", text: "Time flies!"}
    timeline = Timeline.new
               |> Timeline.push(message_from_the_past)
               |> Timeline.push(message_from_the_future)

    assert message_from_the_past in Timeline.wall(timeline, a_time)
    refute message_from_the_future in Timeline.wall(timeline, a_time)
  end

  test "messages are ordered in time, newest first" do
    a_time = Clock.now
    after_1_minute = Clock.at(a_time, {:after, 1, :minute})
    after_2_minutes = Clock.at(a_time, {:after, 2, :minutes})
    after_all = Clock.at(a_time, {:after, 1, :hour})
    first_message = %Message{at: a_time, from: "Alice", text: "Busy at work"}
    second_message = %Message{at: after_1_minute, from: "Alice", text: "Still busy at work"}
    third_message = %Message{at: after_2_minutes, from: "Alice", text: "Going home"}
    timeline = Timeline.new
               |> Timeline.push(first_message)
               |> Timeline.push(third_message)
               |> Timeline.push(second_message)

    assert Timeline.wall(timeline, after_all) == [third_message, second_message, first_message]
  end
end
