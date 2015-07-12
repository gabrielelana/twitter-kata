defmodule Twitter do

  def run(line) when is_binary(line) do
    {:ok, command} = Command.parse(line)
    run(command)
  end

  def run({:post, at, from, message}), do: User.post(from, message, at)
  def run({:read, at, from}), do: User.read(from, at)
  def run({:follow, at, from, who}), do: User.follow(from, who, at)
  def run({:wall, at, from}), do: User.wall(from, at)
end
