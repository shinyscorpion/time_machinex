defmodule TimeMachinex do
  @moduledoc ~S"""
  Define a generic clock api
  """

  @doc ~S"""
  Return the current time from the configured adapter

  Options are:
    precision: :microsecond | :millisecond | :second, default: :millisecond

  ## Examples

  ```elixir
  iex> TimeMachinex.now
  ~U[2019-12-16 00:35:07.571Z]
  ```
  """
  @spec now(keyword) :: DateTime.t()
  def now(opts \\ []) do
    precision = Keyword.get(opts, :precision, :millisecond)
    DateTime.truncate(adapter().now(), precision)
  end

  @doc ~S"""
  Return the current time from the configured adapter

  Options are:
    precision: :microsecond | :millisecond | :second, default: :millisecond

  ## Examples

  ```elixir
  iex> TimeMachinex.utc_now
  ~Z[2019-12-16 00:35:11.422092]
  ```
  """
  @spec utc_now(keyword) :: UTCDateTime.t()
  def utc_now(opts \\ []) do
    precision = Keyword.get(opts, :precision, :millisecond)
    UTCDateTime.truncate(adapter().utc_now(), precision)
  end

  defp adapter do
    case Application.fetch_env(:time_machinex, TimeMachinex) do
      {:ok, config} -> Keyword.get(config, :adapter, TimeMachinex.SystemClock)
      :error -> TimeMachinex.SystemClock
    end
  end
end
