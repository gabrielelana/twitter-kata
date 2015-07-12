defmodule User do
  use GenServer

  defstruct name: ""

  def post(from, message, at \\ now) do
    GenServer.cast(locate(from), {:post, message, at})
  end

  def read(from, at \\ now) do
    GenServer.call(locate(from), {:read, at})
  end

  def follow(from, who, at \\ now) do
    GenServer.cast(locate(from), {:follow, who, at})
  end

  def wall(from, at \\ now) do
    GenServer.call(locate(from), {:wall, at})
  end

  def init(name) do
    {:ok, %User{name: name}}
  end

  def handle_cast({:post, _message, _at}, user) do
    {:noreply, user}
  end
  def handle_cast({:follow, _who, _at}, user) do
    {:noreply, user}
  end

  def handle_call({:read, _at}, _, user) do
    {:reply, :read, user}
  end
  def handle_call({:wall, _at}, _, user) do
    {:reply, :wall, user}
  end

  defp locate(pid) when is_pid(pid), do: pid
  defp locate(name) when is_binary(name) do
    register_name = String.to_atom(name)
    case Process.whereis(register_name) do
      nil ->
        {:ok, pid} = start_link(register_name)
        pid
      pid ->
        pid
    end
  end

  defp start_link(name) do
    GenServer.start_link(User, name, name: name)
  end

  defp now, do: :calendar.local_time
end
