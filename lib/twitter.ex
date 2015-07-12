defmodule Twitter do

  def run(line) when is_binary(line) do
    {:ok, command} = Command.parse(line)
    run(command)
  end

  def run({:post, _at, _from, _message}), do: IO.puts(:post)
  def run({:read, _at, _from}), do: IO.puts(:read)
  def run({:follow, _at, _from, _who}), do: IO.puts(:follow)
  def run({:wall, _at, _from}), do: IO.puts(:wall)
end
