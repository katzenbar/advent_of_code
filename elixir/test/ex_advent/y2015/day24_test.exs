defmodule ExAdvent.Y2015.Day24Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day24

  test "parse input" do
    input = ~s"""
    3
    4
    5
    """

    assert parse_input(input) == [3, 4, 5]
  end

  test "quantum entanglement" do
    assert quantum_entanglement([9, 11]) == 99
  end

  test "find_best_allocation" do
    assert find_best_allocation([1, 2, 3, 4, 5, 7, 8, 9, 10, 11], 3) == 99
  end
end
