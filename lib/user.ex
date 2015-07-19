defmodule Twitter.User do
  @moduledoc """
  Represents the user and all the related informations

  Every user in the system is represented with a server, all users are
  identified by their name and so all processes are locally registered
  using the same name.

  When a user is mentioned for the first time a server is started
  automatically, so there isn't an explicit `start` function
  """

  alias Twitter.User
  alias Twitter.Timeline
  alias Twitter.Message
  alias Twitter.Clock
  use GenServer

  @opaque t :: %User{name: String.t,
                     timeline: Timeline.t,
                     followers: [String.t],
                     following: [String.t]}

  defstruct name: "", timeline: nil, followers: [], following: []

  @doc """
  Post a new message for the user

  Post a message `message` from the user `user` to the `user`'s timeline,
  consider the message created at time `at` (default: current local time)
  """
  @spec post(String.t, String.t, Clock.t) :: :ok
  def post(user, message, at \\ Clock.now) do
    GenServer.cast(locate(user), {:post, message, at})
  end


  @doc """
  Post a new message from another user to the user timeline

  Post a message `message` from the user `from` to the `user`'s timeline,
  consider the message created at time `at` (default: current local time)
  """
  @spec post(String.t, String.t, String.t, Clock.t) :: :ok
  def post(user, from, message, at) do
    GenServer.cast(locate(user), {:post, from, message, at})
  end


  @doc """
  Read all messages sent from the user

  Returns all messages sent from the user `user` before given time (default:
  current local time)
  """
  @spec read(String.t, Clock.t) :: [Message.t]
  def read(user, at \\ Clock.now) do
    GenServer.call(locate(user), {:read, at})
  end


  @doc """
  Follow a user

  User `user` will follow the user `who`. The user `user` will receive all the
  `who` messages and it's timeline will be integrated with all the previous
  `who` messages. The meaning of previous is related to the given time `at`
  (default: current local time)
  """
  @spec follow(String.t, String.t, Clock.t) :: :ok
  def follow(user, who, at \\ Clock.now) do
    GenServer.cast(locate(user), {:follow, who, at})
  end


  @doc false
  def followed_by(user, who, at \\ Clock.now) do
    GenServer.cast(locate(user), {:followed_by, who, at})
  end


  @doc """
  Read all messages in the timeline

  Returns all messages sent from the user `user` and from all the users he
  follows before the given time (default: current local time)
  """
  @spec wall(String.t, Clock.t) :: [Message.t]
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
