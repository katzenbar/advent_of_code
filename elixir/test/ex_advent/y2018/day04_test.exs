defmodule ExAdvent.Y2018.Day04Test do
  use ExUnit.Case

  import ExAdvent.Y2018.Day04

  test "parse input" do
    input = ~s"""
    [1518-11-01 00:00] Guard #10 begins shift
    [1518-11-01 00:05] falls asleep
    [1518-11-01 00:25] wakes up
    [1518-11-01 00:30] falls asleep
    [1518-11-01 00:55] wakes up
    [1518-11-01 23:58] Guard #99 begins shift
    [1518-11-02 00:40] falls asleep
    [1518-11-02 00:50] wakes up
    [1518-11-03 00:05] Guard #10 begins shift
    [1518-11-03 00:24] falls asleep
    [1518-11-03 00:29] wakes up
    [1518-11-04 00:02] Guard #99 begins shift
    [1518-11-04 00:36] falls asleep
    [1518-11-04 00:46] wakes up
    [1518-11-05 00:03] Guard #99 begins shift
    [1518-11-05 00:45] falls asleep
    [1518-11-05 00:55] wakes up
    """

    assert parse_input(input) == [
             {10, [[5, 25], [30, 55]]},
             {99, [[40, 50]]},
             {10, [[24, 29]]},
             {99, [[36, 46]]},
             {99, [[45, 55]]}
           ]
  end

  test "guard_most_minutes_asleep" do
    shifts = [
      {10, [[5, 25], [30, 55]]},
      {99, [[40, 50]]},
      {10, [[24, 29]]},
      {99, [[36, 46]]},
      {99, [[45, 55]]}
    ]

    assert guard_most_minutes_asleep(shifts) == 10
  end

  test "minute_asleep_most" do
    shifts = [
      {10, [[5, 25], [30, 55]]},
      {99, [[40, 50]]},
      {10, [[24, 29]]},
      {99, [[36, 46]]},
      {99, [[45, 55]]}
    ]

    # Asleep during minute 24, 2 times
    assert minute_asleep_most(10, shifts) == {24, 2}
  end

  test "guard_asleep_most_during_minute" do
    shifts = [
      {10, [[5, 25], [30, 55]]},
      {99, [[40, 50]]},
      {10, [[24, 29]]},
      {99, [[36, 46]]},
      {99, [[45, 55]]}
    ]

    assert guard_asleep_most_during_minute(shifts) == {99, 45, 3}
  end
end
