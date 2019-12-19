defmodule TimeMachinex.ManagedClock do
  @moduledoc ~S"""
  Programmable clock
  """
  @behaviour TimeMachinex.Adapter

  @doc false
  @spec start() :: {:ok, pid}
  def start, do: Agent.start_link(&DateTime.utc_now/0, name: __MODULE__)

  @doc false
  @spec set :: :ok
  def set, do: Agent.update(__MODULE__, fn _ -> DateTime.utc_now() end)

  @doc false
  @spec set(DateTime.t() | UTCDateTime.t()) :: :ok
  def set(utc = %UTCDateTime{}),
    do: Agent.update(__MODULE__, fn _ -> UTCDateTime.to_datetime(utc) end)

  def set(datetime), do: Agent.update(__MODULE__, fn _ -> datetime end)

  @impl TimeMachinex.Adapter
  def now, do: Agent.get(__MODULE__, & &1)

  @impl TimeMachinex.Adapter
  def utc_now, do: UTCDateTime.from_datetime(now())

  @impl TimeMachinex.Adapter
  def quoted_now do
    quote do
      Agent.get(unquote(__MODULE__), & &1)
    end
  end

  @impl TimeMachinex.Adapter
  def quoted_utc_now do
    quote do
      unquote(__MODULE__)
      |> Agent.get(& &1)
      |> UTCDateTime.from_datetime()
    end
  end
end
