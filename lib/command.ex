defmodule Twitter.Command do
  use Paco
  alias Twitter.Clock

  parser number, do: while(Paco.ASCII.digit) |> bind(&String.to_integer/1)

  parser at_time do
    {number, skip(lex(":")), number, skip(lex(":")), number}
    |> surrounded_by("[", "]")
    |> bind(fn({h, m, s}) ->
              {date, _} = Clock.now
              {date, {h, m, s}}
            end)
  end

  parser username do
    while(Paco.ASCII.alnum, at_least: 3)
  end

  parser message do
    until(Paco.ASCII.nl, eof: true)
  end

  parser post do
    {always(:post),
     maybe(at_time, default: Clock.now),
     username,
     skip(lex("->")),
     message}
  end

  parser read do
    {always(:read),
     maybe(at_time, default: Clock.now),
     username}
  end

  parser follow do
    {always(:follow),
     maybe(at_time, default: Clock.now),
     username,
     skip(lex("follows")),
     username}
  end

  parser wall do
    {always(:wall),
     maybe(at_time, default: Clock.now),
     username,
     skip(lex("wall"))}
  end

  parser command do
    one_of([post, follow, wall, read])
  end
end
