defmodule Twitter.Message do
  alias Twitter.Message
  alias Twitter.Clock

  defstruct at: Clock.now, from: "", text: ""

  def format_for_wall(%Message{from: from} = message, now) do
    "#{from} - #{format(message, now)}"
  end

  def format(%Message{at: at, text: text}, now) do
    "#{text} (#{Clock.format_elapsed_time(at, now)})"
  end
end
