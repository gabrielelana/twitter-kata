defmodule Twitter.TimelineTest do
  use ExUnit.Case
  alias Twitter.Timeline
  alias Twitter.Message
  alias Twitter.Clock

  test "push single message" do
    now = Clock.now
    message = %Message{at: now, from: "Alice", text: "Busy at work"}
    timeline = Timeline.new |> Timeline.push(message)

    assert Timeline.wall(timeline) == [message]
  end

  test "push messages from multile users" do
    now = Clock.now
    message_from_alice = %Message{at: now, from: "Alice", text: "Busy at work"}
    message_from_bob = %Message{at: now, from: "Bob", text: "Time flies!"}
    timeline = Timeline.new
               |> Timeline.push(message_from_alice)
               |> Timeline.push(message_from_bob)

    assert message_from_alice in Timeline.wall(timeline)
    assert message_from_bob in Timeline.wall(timeline)
  end

  test "filter messages from a user" do
    now = Clock.now
    message_from_alice = %Message{at: now, from: "Alice", text: "Busy at work"}
    message_from_bob = %Message{at: now, from: "Bob", text: "Time flies!"}
    timeline = Timeline.new
               |> Timeline.push(message_from_alice)
               |> Timeline.push(message_from_bob)

    assert message_from_alice in Timeline.from(timeline, "Alice")
    refute message_from_bob in Timeline.from(timeline, "Alice")
  end

  test "filter messages from the future" do
    {date, _} = Clock.now
    message_from_the_past = %Message{at: {date, {10, 0, 0}}, from: "Alice", text: "Busy at work"}
    message_from_the_future = %Message{at: {date, {11, 0, 0}}, from: "Alice", text: "Time flies!"}
    timeline = Timeline.new
               |> Timeline.push(message_from_the_past)
               |> Timeline.push(message_from_the_future)

    assert message_from_the_past in Timeline.wall(timeline, {date, {10, 1, 0}})
    refute message_from_the_future in Timeline.wall(timeline, {date, {10, 1, 0}})
  end

  test "messages are ordered in time, newest first" do
    {date, _} = Clock.yesterday
    first_message = %Message{at: {date, {14,0,0}}, from: "Alice", text: "Busy at work"}
    second_message = %Message{at: {date, {14,0,1}}, from: "Alice", text: "Still busy at work"}
    third_message = %Message{at: {date, {14,1,0}}, from: "Alice", text: "Going home"}
    timeline = Timeline.new
               |> Timeline.push(first_message)
               |> Timeline.push(third_message)
               |> Timeline.push(second_message)

    assert Timeline.wall(timeline) == [third_message, second_message, first_message]
  end
end
