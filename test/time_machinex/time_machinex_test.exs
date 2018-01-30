defmodule TimeMachinexTest do
  @moduledoc false
  use ExUnit.Case, async: false

  alias TimeMachinex.ManagedClock

  describe "now/0" do
    setup do
      Application.delete_env(:time_machinex, TimeMachinex)

      :ok
    end

    test "uses the SystemClock if no config found" do
      now = TimeMachinex.now()
      assert now < TimeMachinex.now()
    end

    test "uses the SystemClock if no adapter provided in the conf" do
      Application.put_env(:time_machinex, TimeMachinex, [])

      now = TimeMachinex.now()
      assert now < TimeMachinex.now()
    end

    test "uses the adapter provided in the conf" do
      Application.put_env(:time_machinex, TimeMachinex, adapter: TimeMachinex.ManagedClock)
      ManagedClock.start()

      now = TimeMachinex.now()
      assert now == TimeMachinex.now()
    end
  end
end
