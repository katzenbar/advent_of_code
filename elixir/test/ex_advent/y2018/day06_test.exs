defmodule ExAdvent.Y2018.Day06Test do
  use ExUnit.Case

  import ExAdvent.Y2018.Day06

  test "parse input" do
    input = ~s"""
    1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9
    """

    assert parse_input(input) == [{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}]
  end

  test "find_largest_area" do
    points = [{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}]

    assert find_largest_area(points) == 17
  end

  test "find_area_near_points" do
    points = [{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}]

    assert find_area_near_points(points, 32) == 16
  end
end
