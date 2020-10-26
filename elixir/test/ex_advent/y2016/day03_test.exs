defmodule ExAdvent.Y2016.Day03Test do
  use ExUnit.Case

  import ExAdvent.Y2016.Day03

  test "parse input" do
    input = ~s"""
    785  516  744
    272  511  358
    """

    assert parse_input(input) == [
             [785, 516, 744],
             [272, 511, 358]
           ]
  end

  test "is_triangle? - false" do
    assert is_triangle?([5, 10, 25]) == false
  end

  test "is_triangle? - true" do
    assert is_triangle?([5, 21, 25]) == true
  end
end
