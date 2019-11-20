# Elixir LiveView Formatter
with static code analyser ;)
__WIP!__
[LiveView](https://github.com/phoenixframework/phoenix_live_view) powered in-browser Elixir code formatter and Credo analyser.

What is [LiveView](https://github.com/phoenixframework/phoenix_live_view)? In short - you can write real-time user interaction code with pure Elixir and get rid off JS!

The functionality is there, now I just need to add some decent CSS styling.

Please bear in mind that Credo is picking up the code wrapped around module (`defmodule`) or function (`def`) definitions, ie - this ugly code will be picked up:
```elixir
def mount(_session, socket) do
  if true do
    if true do
    if true do
        assigns =
          socket
          |> assign(:assign_me, 1)
          |> assign(:assign_me_too, "value")
          |> assign(:hairy, "cattos")
    end
    end
  end
  {:ok, assigns}
end
```
and this one will not:
```elixir
  if true do
    if true do
    if true do
        assigns =
          socket
          |> assign(:assign_me, 1)
          |> assign(:assign_me_too, "value")
          |> assign(:cattos, "furry")
    end
    end
  {:ok, assigns}
```
# Install and run locally
  * Clone repo with `git clone https://github.com/Kociamber/elf.git`
  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install && cd ..`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# TODO
 * work with CSS on some nice layout
 * allow formatting without wrapping code around with `def` and `end` or display
 a message
 * release to hex, host the thing online, add Travis CI
