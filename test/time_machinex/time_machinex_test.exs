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
      :timer.sleep(1000)
      assert now < TimeMachinex.now()
    end

    test "uses the SystemClock if no adapter provided in the conf" do
      Application.put_env(:time_machinex, TimeMachinex, [])

      now = TimeMachinex.now()
      :timer.sleep(1000)
      assert now < TimeMachinex.now()
    end

    test "uses the adapter provided in the conf" do
      Application.put_env(:time_machinex, TimeMachinex, adapter: TimeMachinex.ManagedClock)
      ManagedClock.start()

      now = TimeMachinex.now()
      assert now == TimeMachinex.now()
    end

    test "return the timestamp to the specified precision" do
      Application.put_env(:time_machinex, TimeMachinex, adapter: TimeMachinex.ManagedClock)
      ManagedClock.start()

      assert :eq ==
               DateTime.compare(
                 TimeMachinex.now(precision: :second),
                 TimeMachinex.now(precision: :second)
               )

      assert :lt ==
               DateTime.compare(
                 TimeMachinex.now(precision: :second),
                 TimeMachinex.now(precision: :millisecond)
               )

      assert :lt ==
               DateTime.compare(
                 TimeMachinex.now(precision: :millisecond),
                 TimeMachinex.now(precision: :microsecond)
               )
    end
  end

  describe "utc_now/0" do
    setup do
      Application.delete_env(:time_machinex, TimeMachinex)

      :ok
    end

    test "uses the SystemClock if no config found" do
      now = TimeMachinex.utc_now()
      :timer.sleep(1000)
      assert now < TimeMachinex.utc_now()
    end

    test "uses the SystemClock if no adapter provided in the conf" do
      Application.put_env(:time_machinex, TimeMachinex, [])

      now = TimeMachinex.utc_now()
      :timer.sleep(1000)
      assert now < TimeMachinex.utc_now()
    end

    test "uses the adapter provided in the conf" do
      Application.put_env(:time_machinex, TimeMachinex, adapter: TimeMachinex.ManagedClock)
      ManagedClock.start()

      now = TimeMachinex.utc_now()
      assert now == TimeMachinex.utc_now()
    end

    test "return the timestamp to the specified precision" do
      Application.put_env(:time_machinex, TimeMachinex, adapter: TimeMachinex.ManagedClock)
      ManagedClock.start()

      assert :eq ==
               UTCDateTime.compare(
                 TimeMachinex.utc_now(precision: :second),
                 TimeMachinex.utc_now(precision: :second)
               )

      assert :lt ==
               UTCDateTime.compare(
                 TimeMachinex.utc_now(precision: :second),
                 TimeMachinex.utc_now(precision: :millisecond)
               )

      assert :lt ==
               UTCDateTime.compare(
                 TimeMachinex.utc_now(precision: :millisecond),
                 TimeMachinex.utc_now(precision: :microsecond)
               )
    end
  end
end
