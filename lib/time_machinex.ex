defmodule TimeMachinex do
  @moduledoc """
   Define a generic clock api
  """
  @spec now() :: DateTime.t()
  def now do
    adapter().now
  end

  defp adapter do
    case Application.fetch_env(:time_machinex, TimeMachinex) do
      {:ok, config} -> Keyword.get(config, :adapter, TimeMachinex.SystemClock)
      :error -> TimeMachinex.SystemClock
    end
  end
end
