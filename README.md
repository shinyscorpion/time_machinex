# TimeMachinex
[![Hex.pm](https://img.shields.io/hexpm/v/time_machinex.svg "Hex")](https://hex.pm/packages/time_machinex)
[![Build Status](https://travis-ci.org/shinyscorpion/time_machinex.svg?branch=master)](https://travis-ci.org/shinyscorpion/time_machinex)
[![Hex.pm](https://img.shields.io/hexpm/l/time_machinex.svg "License")](LICENSE.md)
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `time_machinex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:time_machinex, "~> 0.3.0"}
  ]
end
```

## Introduction
TimeMachinex is just a managed clock around the system clock which works with `DateTime.t()` types.

### Configuration
Configuring TimeMachine is very simple. What you generally want to do is to configure the *SystemClock* for `:prod` and `:dev` env:

```elixir
config :time_machinex, TimeMachinex, adapter: TimeMachinex.SystemClock
```

and the *ManagedClock* in the `:test` env:
```elixir
config :time_machinex, TimeMachinex, adapter: TimeMachinex.ManagedClock
```

### Usage
Whenever you need the current system time just replace the standard `DateTime.utc_now/0` call with a `TimeMachinex.utc_now/0` or `TimeMachinex.utc_now/1` call.
Please note that `utc_now` returns an `UTCDateTime` type. (Please use `now/0` and `now/1` if you need a standard `DateTime`)

In `:prod` and `:dev` this will have no real side effects, since the `now/0` function is just an alias for the `DateTime.utc_now/0` thanks to the inline compilation attribute.

The magic happens in the `:test` environment since the `TimeMachinex.ManagedClock` adapter will kick in (if configured properly).
The only thing you need to do in your tests is to start the *ManagedClock*:

    ex(1)> TimeMachinex.ManagedClock.start()
    {:ok, #PID<0.190.0>}

when it starts it is configured with the current time:

    iex(2)> TimeMachinex.ManagedClock.utc_now()
    ~Z[2019-12-16 14:34:32.623987]

but now all the calls to `TimeMachinex.utc_now/0` will read the time from the *ManagedClock*

    iex(3)> TimeMachinex.utc_now()
    ~Z[2019-12-16 14:34:32.623987]

which means that you can manipulate, simulate the time passing and test the time used in your production code.

And yes, you stopped the time!

    iex(4)> TimeMachinex.utc_now()
    ~Z[2019-12-16 14:34:32.623987]
    iex(5)> TimeMachinex.utc_now()
    ~Z[2019-12-16 14:34:32.623987]

If you want to update the TimeMachinex with the current time again (to simulate time passing) you can just:

    iex(7)> TimeMachinex.ManagedClock.set()
    :ok
    iex(8)> TimeMachinex.utc_now()
    ~Z[2019-12-16 14:38:04.255975]

or you may just want to set a specific time and wait for Marty McFly:

    iex(9)> ~N[1985-10-26 09:00:00] |> DateTime.from_naive!("Etc/UTC") |> TimeMachinex.ManagedClock.set()
    :ok

    iex(10)> TimeMachinex.utc_now()
    ~Z[1985-10-26 09:00:00]

Happy time travel!
