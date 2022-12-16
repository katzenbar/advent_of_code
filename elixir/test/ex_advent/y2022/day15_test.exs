defmodule ExAdvent.Y2022.Day15Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day15

  def sample_input() do
    ~s"""
    Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    Sensor at x=9, y=16: closest beacon is at x=10, y=16
    Sensor at x=13, y=2: closest beacon is at x=15, y=3
    Sensor at x=12, y=14: closest beacon is at x=10, y=16
    Sensor at x=10, y=20: closest beacon is at x=10, y=16
    Sensor at x=14, y=17: closest beacon is at x=10, y=16
    Sensor at x=8, y=7: closest beacon is at x=2, y=10
    Sensor at x=2, y=0: closest beacon is at x=2, y=10
    Sensor at x=0, y=11: closest beacon is at x=2, y=10
    Sensor at x=20, y=14: closest beacon is at x=25, y=17
    Sensor at x=17, y=20: closest beacon is at x=21, y=22
    Sensor at x=16, y=7: closest beacon is at x=15, y=3
    Sensor at x=14, y=3: closest beacon is at x=15, y=3
    Sensor at x=20, y=1: closest beacon is at x=15, y=3
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == [
             {{2, 18}, {-2, 15}, 7},
             {{9, 16}, {10, 16}, 1},
             {{13, 2}, {15, 3}, 3},
             {{12, 14}, {10, 16}, 4},
             {{10, 20}, {10, 16}, 4},
             {{14, 17}, {10, 16}, 5},
             {{8, 7}, {2, 10}, 9},
             {{2, 0}, {2, 10}, 10},
             {{0, 11}, {2, 10}, 3},
             {{20, 14}, {25, 17}, 8},
             {{17, 20}, {21, 22}, 6},
             {{16, 7}, {15, 3}, 5},
             {{14, 3}, {15, 3}, 1},
             {{20, 1}, {15, 3}, 7}
           ]
  end

  test "count_impossible_pos_in_row" do
    assert count_impossible_pos_in_row(parsed_sample_input(), 10) == 26
  end

  test "find_beacon_tuning_freq" do
    assert find_beacon_tuning_freq(parsed_sample_input(), 20) == 56_000_011
  end
end
