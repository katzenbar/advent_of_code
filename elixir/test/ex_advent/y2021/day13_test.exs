defmodule ExAdvent.Y2021.Day13Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day13

  def sample_input() do
    ~s"""
    6,10
    0,14
    9,10
    0,3
    10,4
    4,11
    6,0
    6,12
    4,1
    0,13
    10,12
    3,4
    3,0
    8,4
    1,10
    2,14
    8,10
    9,0

    fold along y=7
    fold along x=5
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() ==
             {[
                {6, 10},
                {0, 14},
                {9, 10},
                {0, 3},
                {10, 4},
                {4, 11},
                {6, 0},
                {6, 12},
                {4, 1},
                {0, 13},
                {10, 12},
                {3, 4},
                {3, 0},
                {8, 4},
                {1, 10},
                {2, 14},
                {8, 10},
                {9, 0}
              ], [y: 7, x: 5]}
  end

  test "simulate_fold" do
    {points, [fold | _]} = parsed_sample_input()
    result = simulate_fold(points, fold)
    grid_str = get_grid_string(result)

    expected = ~s"""
    #.##..#..#.
    #...#......
    ......#...#
    #...#......
    .#.#..#.###
    """

    assert grid_str == expected
  end

  test "simulate_folds" do
    result = simulate_folds(parsed_sample_input())
    grid_str = get_grid_string(result)

    expected = ~s"""
    #####
    #...#
    #...#
    #...#
    #####
    """

    assert grid_str == expected
  end

  test "count_points_after_first_fold" do
    assert count_points_after_first_fold(parsed_sample_input()) == 17
  end
end
