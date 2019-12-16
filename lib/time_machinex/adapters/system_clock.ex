defmodule TimeMachinex.SystemClock do
  @moduledoc ~S"""
  System clock implementation
  """
  @compile {:inline, now: 0, utc_now: 0}
  @behaviour TimeMachinex.Adapter

  @impl TimeMachinex.Adapter
  def now, do: DateTime.utc_now()

  @impl TimeMachinex.Adapter
  def utc_now, do: UTCDateTime.utc_now()
end
