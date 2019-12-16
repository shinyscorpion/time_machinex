defmodule TimeMachinex.SystemClockTest do
  @moduledoc false
  use ExUnit.Case, async: false

  alias TimeMachinex.SystemClock

  describe "now/0" do
    test "return the current system time" do
      now = SystemClock.now()

      assert now < SystemClock.now()
    end
  end

  describe "utc_now/0" do
    test "return the current system time" do
      now = SystemClock.utc_now()

      assert now < SystemClock.utc_now()
    end
  end
end
