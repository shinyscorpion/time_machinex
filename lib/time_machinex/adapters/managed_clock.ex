defmodule TimeMachinex.ManagedClock do
  @moduledoc """
  Programmable clock
  """
  @behaviour TimeMachinex.Adapter

  @spec start() :: {:ok, pid}
  def start, do: Agent.start_link(&DateTime.utc_now/0, name: __MODULE__)

  @spec set(DateTime.t()) :: :ok
  def set(new_time \\ DateTime.utc_now()), do: Agent.update(__MODULE__, fn _ -> new_time end)

  @impl TimeMachinex.Adapter
  def now, do: Agent.get(__MODULE__, & &1)
end
