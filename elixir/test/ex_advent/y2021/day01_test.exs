defmodule ExAdvent.Y2021.Day01Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day01

  test "parse input" do
    input = ~s"""
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
    """

    assert parse_input(input) == [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
  end

  test "count_depth_increases" do
    measurements = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

    assert count_depth_increases(measurements) == 7
  end

  test "count_window_depth_increases" do
    measurements = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

    assert count_window_depth_increases(measurements) == 5
  end
end
