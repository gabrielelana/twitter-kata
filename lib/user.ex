defmodule Twitter.User do
  alias Twitter.User
  alias Twitter.Timeline
  alias Twitter.Message
  use GenServer

  defstruct name: "", timeline: nil, followers: [], following: []

  def post(user, message, at \\ now) do
    GenServer.cast(locate(user), {:post, message, at})
  end

  def read(user, at \\ now) do
    GenServer.call(locate(user), {:read, at})
  end

  def follow(user, who, at \\ now) do
    GenServer.cast(locate(user), {:follow, who, at})
  end

  def wall(user, at \\ now) do
    GenServer.call(locate(user), {:wall, at})
  end

  def init(name) do
    {:ok, %User{name: name, timeline: Timeline.new}}
  end

  def handle_cast({:post, message, at}, user) do
    timeline = Timeline.push(user.timeline, %Message{at: at, from: user.name, text: message})
    {:noreply, %User{user|timeline: timeline}}
  end
  def handle_cast({:follow, _who, _at}, user) do
    {:noreply, user}
  end

  def handle_call({:read, at}, _, user) do
    {:reply, Timeline.from(user.timeline, user.name, at), user}
  end
  def handle_call({:wall, _at}, _, user) do
    {:reply, :wall, user}
  end

  defp locate(pid) when is_pid(pid), do: pid
  defp locate(name) when is_binary(name) do
    register_name = String.to_atom(name)
    case Process.whereis(register_name) do
      nil ->
        {:ok, pid} = start_link(name, register_name)
        pid
      pid ->
        pid
    end
  end

  defp start_link(name, register_name) do
    GenServer.start_link(User, name, name: register_name)
  end

  defp now, do: :calendar.local_time
end
