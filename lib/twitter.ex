defmodule Twitter do
  alias Twitter.User
  alias Twitter.Message
  alias Twitter.Command

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

  def run(line) when is_binary(line) do
    {:ok, command} = Command.parse(line)
    run(command)
  end

  def run({:post, at, user, message}) do
    User.post(user, message, at)
  end
  def run({:read, at, user}) do
    User.read(user, at)
    |> Enum.map(&Message.format(&1, at))
    |> Enum.each(&IO.puts/1)
  end
  def run({:follow, at, user, who}) do
    User.follow(user, who, at)
    User.followed_by(who, user, at)
  end
  def run({:wall, at, user}) do
    User.wall(user, at)
    |> Enum.map(&Message.format_for_wall(&1, at))
    |> Enum.each(&IO.puts/1)
  end
end
