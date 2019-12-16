defmodule TimeMachinex.Adapter do
  @moduledoc ~S"""
  Clock behaviour definition
  """

  @doc ~S"""
  Returns the current datetime in UTC.
  """
  @callback now() :: DateTime.t()

  @doc ~S"""
  Returns the current UTC datetime.
  """
  @callback utc_now() :: UTCDateTime.t()
end
