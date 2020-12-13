defmodule ExAdvent.Y2020.Day13Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day13

  test "parse input" do
    input = ~s"""
    939
    7,13,x,x,59,x,31,19
    """

    assert parse_input(input) == {939, [7, 13, nil, nil, 59, nil, 31, 19]}
  end

  test "find_next_bus_for_timestamp" do
    input = {939, [7, 13, nil, nil, 59, nil, 31, 19]}
    # bus 59 departs 5 minutes after timestamp
    assert find_next_bus_for_timestamp(input) == {59, 5}
  end

  test "find_golden_minute - main example" do
    assert find_golden_minute({939, [7, 13, nil, nil, 59, nil, 31, 19]}) == 1_068_781
  end

  test "find_golden_minute - 17,x,13,19" do
    assert find_golden_minute({1, [17, nil, 13, 19]}) == 3417
  end

  test "find_golden_minute - 67,7,59,61" do
    assert find_golden_minute({1, [67, 7, 59, 61]}) == 754_018
  end

  test "find_golden_minute - 67,x,7,59,61" do
    assert find_golden_minute({1, [67, nil, 7, 59, 61]}) == 779_210
  end

  test "find_golden_minute - 67,7,x,59,61" do
    assert find_golden_minute({1, [67, 7, nil, 59, 61]}) == 1_261_476
  end

  test "find_golden_minute - 1789,37,47,1889" do
    assert find_golden_minute({1, [1789, 37, 47, 1889]}) == 1_202_161_486
  end
end
