defmodule Twitter do
  alias Twitter.User

  def run(line) when is_binary(line) do
    {:ok, command} = Command.parse(line)
    run(command)
  end

  def run({:post, at, user, message}), do: User.post(user, message, at)
  def run({:read, at, user}), do: User.read(user, at)
  def run({:follow, at, user, who}), do: User.follow(user, who, at)
  def run({:wall, at, user}), do: User.wall(user, at)
end
