defmodule Twitter.User do
  alias Twitter.User
  alias Twitter.Timeline
  alias Twitter.Message
  alias Twitter.Clock
  use GenServer

  defstruct name: "", timeline: nil, followers: [], following: []

  def post(user, message, at \\ Clock.now) do
    GenServer.cast(locate(user), {:post, message, at})
  end

  def post(user, from, message, at) do
    GenServer.cast(locate(user), {:post, from, message, at})
  end

  def read(user, at \\ Clock.now) do
    GenServer.call(locate(user), {:read, at})
  end

  def follow(user, who, at \\ Clock.now) do
    GenServer.cast(locate(user), {:follow, who, at})
  end

  def followed_by(user, who, at \\ Clock.now) do
    GenServer.cast(locate(user), {:followed_by, who, at})
  end

  def wall(user, at \\ Clock.now) do
    GenServer.call(locate(user), {:wall, at})
  end

  def init(name) do
    {:ok, %User{name: name, timeline: Timeline.new}}
  end

  def handle_cast({:post, message, at}, user) do
    timeline = Timeline.push(user.timeline, %Message{at: at, from: user.name, text: message})
    user.followers |> Enum.each(&User.post(&1, user.name, message, at))
    {:noreply, %User{user|timeline: timeline}}
  end
  def handle_cast({:post, from, message, at}, user) do
    timeline = Timeline.push(user.timeline, %Message{at: at, from: from, text: message})
    {:noreply, %User{user|timeline: timeline}}
  end
  def handle_cast({:follow, who, at}, user) do
    timeline = User.read(who, at) |> Enum.reduce(user.timeline, &Timeline.push(&2, &1))
    {:noreply, %User{user|timeline: timeline, following: [who|user.following]}}
  end
  def handle_cast({:followed_by, who, _at}, user) do
    {:noreply, %User{user|followers: [who|user.followers]}}
  end

  def handle_call({:read, at}, _, user) do
    {:reply, Timeline.from(user.timeline, user.name, at), user}
  end
  def handle_call({:wall, at}, _, user) do
    {:reply, Timeline.wall(user.timeline, at), user}
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
end
