defmodule ExAdvent.Y2018.Day01Test do
  use ExUnit.Case

  import ExAdvent.Y2018.Day01

  test "parse input" do
    input = ~s"""
    +1
    -2
    +3
    +1
    """

    assert parse_input(input) == [1, -2, 3, 1]
  end

  test "get_resulting_frequency - +1, -2, +3, +1" do
    assert get_resulting_frequency([1, -2, 3, 1]) == 3
  end

  test "find_first_duplicate - +1, -2, +3, +1" do
    assert find_first_duplicate([1, -2, 3, 1]) == 2
  end
end
