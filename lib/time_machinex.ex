defmodule TimeMachinex do
  @moduledoc """
   Define a generic clock api
  """

  @doc """
  Return the current time from the configured adapter
  Options are:
    precision: :microsecond | :millisecond | :second, default: :millisecond
  """
  @spec now(keyword) :: DateTime.t()
  def now(opts \\ []) do
    precision = Keyword.get(opts, :precision, :millisecond)
    DateTime.truncate(adapter().now(), precision)
  end

  defp adapter do
    case Application.fetch_env(:time_machinex, TimeMachinex) do
      {:ok, config} -> Keyword.get(config, :adapter, TimeMachinex.SystemClock)
      :error -> TimeMachinex.SystemClock
    end
  end
end
