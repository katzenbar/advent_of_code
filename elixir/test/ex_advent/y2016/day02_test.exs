defmodule ExAdvent.Y2016.Day02Test do
  use ExUnit.Case

  import ExAdvent.Y2016.Day02

  test "parse input" do
    input = ~s"""
    ULL
    RRDDD
    LURDL
    UUUUD
    """

    assert parse_input(input) == [
             [?U, ?L, ?L],
             [?R, ?R, ?D, ?D, ?D],
             [?L, ?U, ?R, ?D, ?L],
             [?U, ?U, ?U, ?U, ?D]
           ]
  end

  test "find_code" do
    directions = [
      [?U, ?L, ?L],
      [?R, ?R, ?D, ?D, ?D],
      [?L, ?U, ?R, ?D, ?L],
      [?U, ?U, ?U, ?U, ?D]
    ]

    assert find_code(directions, part1_map()) == "1985"
  end
end
