defmodule ExAdvent.Y2020.Day15Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day15

  test "parse input" do
    input = "0,3,6"
    assert parse_input(input) == [0, 3, 6]
  end

  test "generate_next_number - number has not been spoken" do
    state = {3, 6, %{0 => 1, 3 => 2}}
    expected = {4, 0, %{0 => 1, 3 => 2, 6 => 3}}

    assert generate_next_number(state) == expected
  end

  test "generate_next_number - number has been spoken" do
    state = {4, 0, %{0 => 1, 3 => 2, 6 => 3}}
    expected = {5, 3, %{0 => 4, 3 => 2, 6 => 3}}

    assert generate_next_number(state) == expected
  end

  test "find_nth_number - 10th in 0,3,6" do
    assert find_nth_number([0, 3, 6], 10) == 0
  end

  test "find_nth_number - 2020th in 0,3,6" do
    assert find_nth_number([0, 3, 6], 2020) == 436
  end

  test "find_nth_number - 2020th in 2,3,1" do
    assert find_nth_number([2, 3, 1], 2020) == 78
  end

  # test "find_nth_number - 30000000th in 2,3,1" do
  #   assert find_nth_number([2, 3, 1], 30_000_000) == 6_895_259
  # end
end
