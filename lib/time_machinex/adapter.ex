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

  @doc ~S"""
  Returns quoted expression to get the current datetime in UTC.
  """
  @callback quoted_now() :: term

  @doc ~S"""
  Returns quoted expression to get the current UTC datetime.
  """
  @callback quoted_utc_now() :: term
end
