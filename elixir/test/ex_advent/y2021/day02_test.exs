defmodule ExAdvent.Y2021.Day02Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day02

  test "parse input" do
    input = ~s"""
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
    """

    assert parse_input(input) == [forward: 5, down: 5, forward: 8, up: 3, down: 8, forward: 2]
  end

  test "get_final_up_down_position" do
    assert get_final_up_down_position([forward: 5, down: 5, forward: 8, up: 3, down: 8, forward: 2]) == {15, 10}
  end

  test "get_final_aim_position" do
    assert get_final_aim_position([forward: 5, down: 5, forward: 8, up: 3, down: 8, forward: 2]) == {15, 60, 10}
  end
end
