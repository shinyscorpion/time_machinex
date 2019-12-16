defmodule TimeMachinex.ManagedClockTest do
  @moduledoc false
  use ExUnit.Case, async: false
  use UTCDateTime

  alias TimeMachinex.ManagedClock

  @past ~N[1970-01-01 10:10:10]
  @past_utc ~Z[1970-01-01 10:10:10]

  describe "start/1" do
    test "starts the sigleton agent" do
      assert {:ok, _pid} = ManagedClock.start()
      assert {:error, {:already_started, _pid}} = ManagedClock.start()
    end
  end

  describe "now/0" do
    setup do
      ManagedClock.start()

      :ok
    end

    test "return the time set in the time machine" do
      now = ManagedClock.now()
      assert now < DateTime.utc_now()
      assert now == ManagedClock.now()

      ManagedClock.set(DateTime.from_naive!(@past, "Etc/UTC"))
      assert DateTime.from_naive!(@past, "Etc/UTC") == ManagedClock.now()
    end
  end

  describe "set/1" do
    setup do
      ManagedClock.start()

      :ok
    end

    test "set the time in the time machine to the new system time as default" do
      now = ManagedClock.now()

      ManagedClock.set()

      assert now < ManagedClock.now()
    end

    test "set the time in the time machine to a specific value" do
      ManagedClock.set(DateTime.from_naive!(@past, "Etc/UTC"))

      assert ManagedClock.now() < DateTime.utc_now()
    end
  end

  describe "utc_now/0" do
    setup do
      ManagedClock.start()

      :ok
    end

    test "return the time set in the time machine" do
      now = ManagedClock.utc_now()
      assert now < UTCDateTime.utc_now()
      assert now == ManagedClock.utc_now()

      ManagedClock.set(@past_utc)
      assert ManagedClock.utc_now() == @past_utc
    end
  end
end
