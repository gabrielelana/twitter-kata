# Twitter-Kata
[![Build Status](https://travis-ci.org/gabrielelana/twitter-kata.svg?branch=master)](https://travis-ci.org/gabrielelana/twitter-kata)

### Twitter like console-based application Kata

## Usage
* it's an interactive shell
* type `mix start` or `twitter` to run the shell (see below)
* type `Ctrl-D` to leave once in the shell
* all users shares the same console so to identify a user prepend his name to the command
* the `> ` character is the prompt and can be ignored
* user `Mark` can send a message with `Mark -> Hi!`
* user `Mark` can follow user `Sandy` with `Mark follows Sandy`
* view messages of the user `Mark` with `Mark`
* view messages of the user `Mark` and all the users he follows with `Mark wall`

### Example
```
Type Ctrl-D to leave
> Charlie -> I'm in New York today! Anyone want to have a coffee?
> Charlie
I'm in New York today! Anyone want to have a coffee? (just now)
> Charlie follows Alice
> Charlie wall
Charlie - I'm in New York today! Anyone want to have a coffee? (2 seconds ago)
Alice - I love the weather today (5 minutes ago)
> Charlie follows Bob
> Charlie wall
Charlie - I'm in New York today! Anyone wants to have a coffee? (15 seconds ago)
Bob - Good game though. (1 minute ago)
Bob - Damn! We lost! (2 minutes ago)
Alice - I love the weather today (5 minutes ago)
```

## How to Run
* install [Elixir](http://elixir-lang.org/install.html)
* clone this project `git clone https://github.com/gabrielelana/twitter-kata`
* enter the project directory `cd twitter-kata`
* try it on the fly with `mix start`
* build `twitter` executable with `mix escript.build` then you can leave the executable in the project directory or copy it wherever you want, it only depends on `Elixir`
