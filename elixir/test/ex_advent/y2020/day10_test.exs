defmodule ExAdvent.Y2020.Day10Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day10

  test "parse input" do
    input = ~s"""
    16
    10
    15
    5
    1
    11
    7
    19
    6
    12
    4
    """

    assert parse_input(input) == [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
  end

  test "find_difference_counts - small" do
    adapters = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
    assert find_difference_counts(adapters) == {6, 0, 4}
  end

  test "find_difference_counts - large" do
    adapters = [
      28,
      33,
      18,
      42,
      31,
      14,
      46,
      20,
      48,
      47,
      24,
      23,
      49,
      45,
      19,
      38,
      39,
      11,
      1,
      32,
      25,
      35,
      8,
      17,
      7,
      9,
      4,
      2,
      34,
      10,
      3
    ]

    assert find_difference_counts(adapters) == {21, 0, 9}
  end

  test "find_possible_combinations - small" do
    adapters = [0, 22, 16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
    assert find_possible_combinations(adapters) == 8
  end

  test "find_possible_combinations - large" do
    adapters = [
      0,
      52,
      28,
      33,
      18,
      42,
      31,
      14,
      46,
      20,
      48,
      47,
      24,
      23,
      49,
      45,
      19,
      38,
      39,
      11,
      1,
      32,
      25,
      35,
      8,
      17,
      7,
      9,
      4,
      2,
      34,
      10,
      3
    ]

    assert find_possible_combinations(adapters) == 19208
  end

  test "number_of_combinations" do
    assert number_of_combinations(4, 2) == 6
  end
end
