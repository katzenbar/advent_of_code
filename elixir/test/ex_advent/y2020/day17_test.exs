defmodule ExAdvent.Y2020.Day17Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day17

  test "parse input - 3d" do
    input = ~s"""
    .#.
    ..#
    ###
    """

    assert parse_input(input, 3) == %{
             [0, 0, 0] => false,
             [0, 1, 0] => false,
             [0, 2, 0] => true,
             [1, 0, 0] => true,
             [1, 1, 0] => false,
             [1, 2, 0] => true,
             [2, 0, 0] => false,
             [2, 1, 0] => true,
             [2, 2, 0] => true
           }
  end

  test "parse input - 4d" do
    input = ~s"""
    .#.
    ..#
    ###
    """

    assert parse_input(input, 4) == %{
             [0, 0, 0, 0] => false,
             [0, 1, 0, 0] => false,
             [0, 2, 0, 0] => true,
             [1, 0, 0, 0] => true,
             [1, 1, 0, 0] => false,
             [1, 2, 0, 0] => true,
             [2, 0, 0, 0] => false,
             [2, 1, 0, 0] => true,
             [2, 2, 0, 0] => true
           }
  end

  test "execute_cycle" do
    grid = %{
      [0, 0, 0] => false,
      [0, 1, 0] => false,
      [0, 2, 0] => true,
      [1, 0, 0] => true,
      [1, 1, 0] => false,
      [1, 2, 0] => true,
      [2, 0, 0] => false,
      [2, 1, 0] => true,
      [2, 2, 0] => true
    }

    assert execute_cycle(grid) == %{
             [0, 1, -1] => true,
             [0, 1, 0] => true,
             [0, 1, 1] => true,
             [1, 2, 0] => true,
             [1, 3, -1] => true,
             [1, 3, 0] => true,
             [1, 3, 1] => true,
             [2, 1, 0] => true,
             [2, 2, -1] => true,
             [2, 2, 0] => true,
             [2, 2, 1] => true
           }
  end

  test "execute_boot_process" do
    grid = %{
      [0, 0, 0] => false,
      [0, 1, 0] => false,
      [0, 2, 0] => true,
      [1, 0, 0] => true,
      [1, 1, 0] => false,
      [1, 2, 0] => true,
      [2, 0, 0] => false,
      [2, 1, 0] => true,
      [2, 2, 0] => true
    }

    assert execute_boot_process(grid) |> Enum.count() == 112
  end

  test "generate_coordinates_between" do
    assert generate_coordinates_between([0, 0], [1, 1]) == [[0, 0], [0, 1], [1, 0], [1, 1]]
  end
end
