defmodule Twitter.CommandTest do
  use ExUnit.Case
  alias Twitter.Command
  alias Twitter.Clock

  test "parse post command" do
    assert {:post, _, "Alice", "Busy at work"} = Command.parse("Alice -> Busy at work", format: :flat)
  end

  test "parse read command" do
    assert {:read, _, "Alice"} = Command.parse("Alice", format: :flat)
  end

  test "parse follow command" do
    assert {:follow, _, "Alice", "Bob"} = Command.parse("Alice follows Bob", format: :flat)
  end

  test "parse wall command" do
    assert {:wall, _, "Alice"} = Command.parse("Alice wall", format: :flat)
  end

  test "command with time" do
    {today, _} = Clock.now
    assert Command.parse("[14:00:00] XXX -> YYY", format: :flat) == {:post, {today, {14, 0, 0}}, "XXX", "YYY"}
    assert Command.parse("[14:09:02] XXX -> YYY", format: :flat) == {:post, {today, {14, 9, 2}}, "XXX", "YYY"}
  end
end
