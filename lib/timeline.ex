defmodule Twitter.Timeline do
  @moduledoc """
  Represents a time ordered list of messages
  """

  alias Twitter.Message
  alias Twitter.Clock

  @type t :: [Message.t]

  @doc """
  Creates a new timeline
  """
  @spec new :: t
  def new, do: []


  @doc """
  Returns all the messages before a given time

  Returns all the messages before `at` (default: current local time)
  """
  @spec wall(t, Clock.t) :: t
  def wall(timeline, at \\ Clock.now) do
    timeline |> Enum.filter(&(&1.at <= at))
  end


  @doc """
  Returns all the message sent from a user

  Returns all the messages sent from `user` before `at` (default: current local time)
  """
  @spec from(t, String.t, Clock.t) :: t
  def from(timeline, user, at \\ Clock.now) do
    wall(timeline, at) |> Enum.filter(&from?(&1, user))
  end


  @doc """
  Ad a message to the timeline
  """
  @spec push(t, Message.t) :: t
  def push(timeline, message) do
    [message | timeline] |> Enum.sort(&(&1.at > &2.at))
  end


  defp from?(%Message{from: user}, user), do: true
  defp from?(_, _),                       do: false
end
