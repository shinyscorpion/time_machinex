defmodule TimeMachinex.SystemClock do
  @moduledoc """
  System clock implementation
  """
  @compile {:inline, now: 0}
  @behaviour TimeMachinex.Adapter

  @impl TimeMachinex.Adapter
  def now, do: DateTime.utc_now()
end
