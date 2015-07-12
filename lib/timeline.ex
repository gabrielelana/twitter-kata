defmodule Twitter.Timeline do
  alias Twitter.Message

  def new, do: []

  def wall(timeline), do: timeline

  def from(timeline, user) do
    timeline |> Enum.filter(&from?(&1, user))
  end

  def push(timeline, message) do
    [message | timeline] |> Enum.sort(&(&1.at > &2.at))
  end

  defp from?(%Message{from: user}, user), do: true
  defp from?(_, _),                       do: false
end
