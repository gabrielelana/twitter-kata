defmodule Twitter do
  @moduledoc """
  Implements a console-based social networking application similar to Twitter
  """

  alias Twitter.User
  alias Twitter.Message
  alias Twitter.Command

  @doc """
  Starts the interactive shell
  """
  @spec main([String.t]) :: any
  def main(_args) do
    explain_how_to_leave
    ask_for_command("> ")
  end

  defp explain_how_to_leave do
    IO.puts("Type Ctrl-D to leave")
  end

  defp ask_for_command(prompt) do
    case IO.gets(prompt) do
      {:error, reason} ->
        IO.puts("! #{reason}")
      :eof ->
        IO.puts("Bye")
      line ->
        run(line)
        ask_for_command(prompt)
    end
  end


  @doc """
  Parse and run one of the supported commands

  * posting: <username> -> <message>
  * reading: <username>
  * following: <username> follows <another-username>
  * wall: <username> wall

  Output goes directly to STDOUT
  """
  @spec run(String.t) :: :ok
  def run(line) do
    case Command.parse(line) do
      {:ok, command} -> do_run(command)
      {:error, reason} -> IO.puts("! #{reason}")
    end
  end

  defp do_run({:post, at, user, message}) do
    User.post(user, message, at)
  end
  defp do_run({:read, at, user}) do
    User.read(user, at)
    |> Enum.map(&Message.format(&1, at))
    |> Enum.each(&IO.puts/1)
  end
  defp do_run({:follow, at, user, who}) do
    User.follow(user, who, at)
    User.followed_by(who, user, at)
  end
  defp do_run({:wall, at, user}) do
    User.wall(user, at)
    |> Enum.map(&Message.format_for_wall(&1, at))
    |> Enum.each(&IO.puts/1)
  end
end
