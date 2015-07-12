defmodule Twitter.ScenarioTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @tag :acceptance
  test "posting" do
    scenario """
    > [14:00:00] Alice -> I love the weather today
    > [14:03:00] Bob -> Damn! We lost!
    > [14:04:00] Bob -> Good game though.
    """
  end

  @tag :acceptance
  test "reading" do
    scenario """
    > [14:00:00] Alice -> I love the weather today
    > [14:03:00] Bob -> Damn! We lost!
    > [14:04:00] Bob -> Good game though.
    > [14:05:00] Alice
    I love the weather today (5 minutes ago)
    > [14:05:00] Bob
    Good game though. (1 minute ago)
    Damn! We lost! (2 minutes ago)
    """
  end

  @tag :acceptance
  test "following" do
    scenario """
    > [14:00:00] Alice -> I love the weather today
    > [14:03:00] Bob -> Damn! We lost!
    > [14:04:00] Bob -> Good game though.
    > [14:05:00] Charlie -> I'm in New York today! Anyone want to have a coffee?
    > [14:05:00] Charlie follows Alice
    > [14:05:02] Charlie wall
    Charlie - I'm in New York today! Anyone want to have a coffee? (2 seconds ago)
    Alice - I love the weather today (5 minutes ago)
    > [14:05:15] Charlie follows Bob
    > [14:05:15] Charlie wall
    Charlie - I'm in New York today! Anyone want to have a coffee? (15 seconds ago)
    Bob - Good game though. (1 minute ago)
    Bob - Damn! We lost! (2 minutes ago)
    Alice - I love the weather today (5 minutes ago)
    """
  end


  @tag :acceptance
  test "push to followers" do
    scenario """
    > [14:03:00] Bob -> Damn! We lost!
    > [14:04:00] Bob -> Good game though.
    > [14:05:00] Charlie follows Bob
    > [14:05:00] Charlie wall
    Bob - Good game though. (1 minute ago)
    Bob - Damn! We lost! (2 minutes ago)
    > [14:05:00] Bob -> Going to sleep...
    > [14:06:00] Charlie wall
    Bob - Going to sleep... (1 minute ago)
    Bob - Good game though. (2 minutes ago)
    Bob - Damn! We lost! (3 minutes ago)
    """
  end


  defp scenario(log) do
    given_input = extract_input_from(log)
    expected_output = extract_output_from(log)
    captured_output = capture_io(given_input, fn -> run(given_input) end)
    assert String.strip(captured_output) == expected_output
  end

  defp extract_input_from(log) do
    log
    |> String.split("\n")
    |> Enum.filter(&String.starts_with?(&1, ">"))
    |> Enum.map(&Regex.replace(~r/^>\s*/, &1, ""))
    |> Enum.reject(&(String.length(&1) == 0))
    |> Enum.join("\n")
  end

  defp extract_output_from(log) do
    log
    |> String.split("\n")
    |> Enum.reject(&String.starts_with?(&1, ">"))
    |> Enum.reject(&(String.length(&1) == 0))
    |> Enum.join("\n")
  end

  defp run(input) do
    input
    |> String.split("\n")
    |> Enum.each(&Twitter.run/1)
  end
end
