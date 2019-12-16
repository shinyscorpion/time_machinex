defmodule TimeMachinex do
  @moduledoc ~S"""
  Define a generic clock api
  """
  @default_precision :microsecond
  @dynamic :time_machinex
           |> Application.get_env(TimeMachinex, [])
           |> Keyword.get(:dynamic, Mix.env() == :test)

  @doc """
  Return the current time from the configured adapter

  Options are:
    precision: :microsecond | :millisecond | :second, default: #{@default_precision}

  ## Examples

  ```elixir
  iex> TimeMachinex.now
  ~U[2019-12-16 00:35:07.571Z]
  ```
  """
  if @dynamic do
    @spec now(keyword) :: DateTime.t()
    def now(opts \\ []) do
      precision = Keyword.get(opts, :precision, @default_precision)
      DateTime.truncate(adapter().now(), precision)
    end
  else
    @spec now(keyword) :: term
    defmacro now(opts \\ []) do
      precision = Keyword.get(opts, :precision, @default_precision)

      if precision == :microsecond do
        adapter().quoted_now()
      else
        quote do
          DateTime.truncate(unquote(adapter().quoted_now()), unquote(precision))
        end
      end
    end
  end

  @doc """
  Return the current time from the configured adapter

  Options are:
    precision: :microsecond | :millisecond | :second, default: #{@default_precision}

  ## Examples

  ```elixir
  iex> TimeMachinex.utc_now
  ~Z[2019-12-16 00:35:11.422092]
  ```
  """
  @spec utc_now(keyword) :: UTCDateTime.t()
  if @dynamic do
    @spec utc_now(keyword) :: DateTime.t()
    def utc_now(opts \\ []) do
      precision = Keyword.get(opts, :precision, @default_precision)
      UTCDateTime.truncate(adapter().utc_now(), precision)
    end
  else
    @spec utc_now(keyword) :: term
    defmacro utc_now(opts \\ []) do
      precision = Keyword.get(opts, :precision, @default_precision)

      if precision == :microsecond do
        adapter().quoted_utc_now()
      else
        quote do
          UTCDateTime.truncate(unquote(adapter().quoted_utc_now()), unquote(precision))
        end
      end
    end
  end

  @doc ~S"""
  [Re]Configure TimeMachinex.

  Only works in `:test` mode or when configured with `dynamic: true`.

  ## Examples

  ```elixir
  iex> TimeMachinex.configure(adapter: TimeMachinex.ManagedClock)
  """
  if @dynamic do
    @spec configure(opts :: Keyword.t()) :: :ok
    def configure(opts) do
      new_opts = :time_machinex |> Application.get_env(TimeMachinex, []) |> Keyword.merge(opts)
      Application.put_env(:time_machinex, TimeMachinex, new_opts)

      :ok
    end
  else
    @spec configure(opts :: Keyword.t()) :: no_return
    def configure(_opts) do
      raise "TimeMachinex needs to be configured with `dynamic: true` to allow configuration updates outside `:test`."
    end
  end

  defp adapter do
    case Application.fetch_env(:time_machinex, TimeMachinex) do
      {:ok, config} -> Keyword.get(config, :adapter, TimeMachinex.SystemClock)
      :error -> TimeMachinex.SystemClock
    end
  end
end
