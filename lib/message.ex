defmodule Twitter.Message do
  @moduledoc """
  Represent a message sent from a user
  """

  alias Twitter.Message
  alias Twitter.Clock

  @type t :: %Message{at: Clock.t,
                      from: String.t,
                      text: String.t}

  defstruct at: Clock.now, from: "", text: ""


  @doc """
  Formats the message for the wall

  Formats the message for the wall given the current time is `now`
  """
  @spec format_for_wall(t, Clock.t) :: String.t
  def format_for_wall(%Message{from: from} = message, now) do
    "#{from} - #{format(message, now)}"
  end


  @doc """
  Formats the message

  Formats the message given the current time is `now`
  """
  @spec format(t, Clock.t) :: String.t
  def format(%Message{at: at, text: text}, now) do
    "#{text} (#{Clock.format_elapsed_time(at, now)})"
  end
end
