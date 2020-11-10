defmodule ExAdvent.Y2016.Day08Test do
  use ExUnit.Case

  import ExAdvent.Y2016.Day08

  test "parse input" do
    input = ~s"""
    rect 3x2
    rotate column x=1 by 1
    rotate row y=0 by 4
    rotate column x=1 by 1
    """

    assert parse_input(input) == [
             {:rect, 3, 2},
             {:rotate_col, 1, 1},
             {:rotate_row, 0, 4},
             {:rotate_col, 1, 1}
           ]
  end

  test "parse_line - rect" do
    input = "rect 6x1"
    assert parse_line(input) == {:rect, 6, 1}
  end

  test "parse_line - rotate row" do
    input = "rotate row y=0 by 5"
    assert parse_line(input) == {:rotate_row, 0, 5}
  end

  test "parse_line - rotate column" do
    input = "rotate column x=1 by 3"
    assert parse_line(input) == {:rotate_col, 1, 3}
  end

  test "build_grid" do
    build_grid(2, 3) == [
      [0, 0],
      [0, 0],
      [0, 0]
    ]
  end

  test "execute_instruction - rect" do
    grid = build_grid(3, 2)
    instruction = {:rect, 2, 1}

    assert execute_instruction(instruction, grid) == [
             [1, 1, 0],
             [0, 0, 0]
           ]
  end

  test "execute_instruction - rotate_row" do
    grid = [[0, 0, 0, 1]]
    instruction = {:rotate_row, 0, 1}

    assert execute_instruction(instruction, grid) == [
             [1, 0, 0, 0]
           ]
  end

  test "execute_instruction - rotate_column" do
    grid = [
      [0, 1],
      [1, 0],
      [0, 0],
      [0, 1]
    ]

    instruction = {:rotate_col, 1, 2}

    assert execute_instruction(instruction, grid) == [
             [0, 0],
             [1, 1],
             [0, 1],
             [0, 0]
           ]
  end
end
