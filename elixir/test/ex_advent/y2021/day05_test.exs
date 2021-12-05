defmodule ExAdvent.Y2021.Day05Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day05

  def sample_input() do
    ~s"""
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
    """
  end

  test "parse input" do
    assert parse_input(sample_input()) == [
             [[0, 9], [5, 9]],
             [[8, 0], [0, 8]],
             [[9, 4], [3, 4]],
             [[2, 2], [2, 1]],
             [[7, 0], [7, 4]],
             [[6, 4], [2, 0]],
             [[0, 9], [2, 9]],
             [[3, 4], [1, 4]],
             [[0, 0], [8, 8]],
             [[5, 5], [8, 2]]
           ]
  end

  test "filter_to_horizontal_and_vertical_lines" do
    all_lines = [
      [[0, 9], [5, 9]],
      [[8, 0], [0, 8]],
      [[9, 4], [3, 4]],
      [[2, 2], [2, 1]],
      [[7, 0], [7, 4]],
      [[6, 4], [2, 0]],
      [[0, 9], [2, 9]],
      [[3, 4], [1, 4]],
      [[0, 0], [8, 8]],
      [[5, 5], [8, 2]]
    ]

    horiz_vert_lines = [
      [[0, 9], [5, 9]],
      [[9, 4], [3, 4]],
      [[2, 2], [2, 1]],
      [[7, 0], [7, 4]],
      [[0, 9], [2, 9]],
      [[3, 4], [1, 4]]
    ]

    assert filter_to_horizontal_and_vertical_lines(all_lines) == horiz_vert_lines
  end

  test "count_covered_points - horizontal and vertical only" do
    lines = [
      [[0, 9], [5, 9]],
      [[9, 4], [3, 4]],
      [[2, 2], [2, 1]],
      [[7, 0], [7, 4]],
      [[0, 9], [2, 9]],
      [[3, 4], [1, 4]]
    ]

    covered_points = count_covered_points(lines)

    display_map(lines, covered_points)

    assert covered_points == %{
             "0,9" => 2,
             "1,4" => 1,
             "1,9" => 2,
             "2,2" => 1,
             "2,4" => 1,
             "2,9" => 2,
             "3,4" => 2,
             "3,9" => 1,
             "4,4" => 1,
             "4,9" => 1,
             "5,4" => 1,
             "5,9" => 1,
             "6,4" => 1,
             "7,4" => 2,
             "8,4" => 1,
             "9,4" => 1,
             "2,1" => 1,
             "7,0" => 1,
             "7,1" => 1,
             "7,2" => 1,
             "7,3" => 1
           }
  end

  test "count_covered_points - full example" do
    lines = parse_input(sample_input())
    covered_points = count_covered_points(lines)
    display_map(lines, covered_points)

    assert covered_points == %{
             "0,0" => 1,
             "0,8" => 1,
             "0,9" => 2,
             "1,1" => 1,
             "1,4" => 1,
             "1,7" => 1,
             "1,9" => 2,
             "2,0" => 1,
             "2,2" => 2,
             "2,4" => 1,
             "2,6" => 1,
             "2,9" => 2,
             "3,1" => 1,
             "3,3" => 1,
             "3,4" => 2,
             "3,5" => 1,
             "3,9" => 1,
             "4,2" => 1,
             "4,4" => 3,
             "4,9" => 1,
             "5,3" => 2,
             "5,4" => 1,
             "5,5" => 2,
             "5,9" => 1,
             "6,2" => 1,
             "6,4" => 3,
             "6,6" => 1,
             "7,1" => 2,
             "7,3" => 2,
             "7,4" => 2,
             "7,7" => 1,
             "8,0" => 1,
             "8,2" => 1,
             "8,4" => 1,
             "8,8" => 1,
             "9,4" => 1,
             "2,1" => 1,
             "7,0" => 1,
             "7,2" => 1
           }
  end

  test "count_points_with_overlaps - horizontal and vertical only" do
    lines = [
      [[0, 9], [5, 9]],
      [[9, 4], [3, 4]],
      [[2, 2], [2, 1]],
      [[7, 0], [7, 4]],
      [[0, 9], [2, 9]],
      [[3, 4], [1, 4]]
    ]

    assert count_points_with_overlaps(lines) == 5
  end
end
