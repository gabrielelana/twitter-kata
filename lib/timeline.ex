defmodule Twitter.Timeline do
  alias Twitter.Message
  alias Twitter.Clock

  def new, do: []

  def wall(timeline, at \\ Clock.now) do
    timeline |> Enum.filter(&(&1.at <= at))
  end

  def from(timeline, user, at \\ Clock.now) do
    wall(timeline, at) |> Enum.filter(&from?(&1, user))
  end

  def push(timeline, message) do
    [message | timeline] |> Enum.sort(&(&1.at > &2.at))
  end

  defp from?(%Message{from: user}, user), do: true
  defp from?(_, _),                       do: false
end
