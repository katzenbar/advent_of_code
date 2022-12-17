defmodule ExAdvent.Y2022.Day17Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day17

  def sample_input() do
    ~s"""
    >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == [
             ">",
             ">",
             ">",
             "<",
             "<",
             ">",
             "<",
             ">",
             ">",
             "<",
             "<",
             "<",
             ">",
             ">",
             "<",
             ">",
             ">",
             ">",
             "<",
             "<",
             "<",
             ">",
             ">",
             ">",
             "<",
             "<",
             "<",
             ">",
             "<",
             "<",
             "<",
             ">",
             ">",
             "<",
             ">",
             ">",
             "<",
             "<",
             ">",
             ">"
           ]
  end

  test "get_highest_pos_after - 2022" do
    assert get_highest_pos_after(parsed_sample_input(), 2022) == 3068
  end

  test "get_highest_pos_after - 1000000000000" do
    assert get_highest_pos_after(parsed_sample_input(), 1_000_000_000_000) == 1_514_285_714_288
  end
end
