defmodule TimeMachinex.Adapter do
  @moduledoc """
  Clock behaviour definition
  """

  @callback now() :: DateTime.t()
end
