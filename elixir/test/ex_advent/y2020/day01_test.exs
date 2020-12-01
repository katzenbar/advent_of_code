defmodule ExAdvent.Y2020.Day01Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day01

  test "parse input" do
    input = ~s"""
    1721
    979
    366
    299
    675
    1456
    """

    assert parse_input(input) == [
             1721,
             979,
             366,
             299,
             675,
             1456
           ]
  end

  test "find_two_elements_with_sum" do
    input = [
      1721,
      979,
      366,
      299,
      675,
      1456
    ]

    assert find_two_elements_with_sum(input, 2020) == [1721, 299]
  end

  test "find_three_elements_with_sum" do
    input = [
      1721,
      979,
      366,
      299,
      675,
      1456
    ]

    assert find_three_elements_with_sum(input, 2020) == [979, 366, 675]
  end
end
