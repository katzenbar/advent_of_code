defmodule ExAdvent.Y2021.Day09Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day09

  def sample_input() do
    ~s"""
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == [
             [2, 1, 9, 9, 9, 4, 3, 2, 1, 0],
             [3, 9, 8, 7, 8, 9, 4, 9, 2, 1],
             [9, 8, 5, 6, 7, 8, 9, 8, 9, 2],
             [8, 7, 6, 7, 8, 9, 6, 7, 8, 9],
             [9, 8, 9, 9, 9, 6, 5, 6, 7, 8]
           ]
  end

  test "sum_risk_levels" do
    assert sum_risk_levels(parsed_sample_input()) == 15
  end

  test "find_basins" do
    assert find_basins(parsed_sample_input()) == [
             MapSet.new([
               "0,3",
               "1,2",
               "1,3",
               "1,4",
               "2,1",
               "2,2",
               "2,3",
               "3,1",
               "3,2",
               "3,3",
               "4,1",
               "4,2",
               "4,3",
               "5,2"
             ]),
             MapSet.new(["0,0", "0,1", "1,0"]),
             MapSet.new(["5,4", "6,3", "6,4", "7,2", "7,3", "7,4", "8,3", "8,4", "9,4"]),
             MapSet.new(["5,0", "6,0", "6,1", "7,0", "8,0", "8,1", "9,0", "9,1", "9,2"])
           ]
  end

  test "find_basin - 1,0" do
    height_map = convert_height_map_from_list_to_map(parsed_sample_input())

    assert find_basin("1,0", height_map) == MapSet.new(["0,0", "0,1", "1,0"])
  end

  test "find_basin - 2,2" do
    height_map = convert_height_map_from_list_to_map(parsed_sample_input())

    assert find_basin("2,2", height_map) ==
             MapSet.new([
               "0,3",
               "1,2",
               "1,3",
               "1,4",
               "2,1",
               "2,2",
               "2,3",
               "3,1",
               "3,2",
               "3,3",
               "4,1",
               "4,2",
               "4,3",
               "5,2"
             ])
  end

  test "multiply_largest_basins_size" do
    assert multiply_largest_basins_size(parsed_sample_input()) == 1134
  end
end
