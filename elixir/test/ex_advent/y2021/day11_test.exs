defmodule ExAdvent.Y2021.Day11Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day11

  def sample_input() do
    ~s"""
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    grid = parsed_sample_input()
    assert Map.get(grid, "0,0") == 5
    assert Map.get(grid, "9,9") == 6
    assert Map.get(grid, "2,3") == 4
  end

  test "simulate_step - first step - no flashes" do
    result = simulate_step(parsed_sample_input())

    expected = ~s"""
    6594254334
    3856965822
    6375667284
    7252447257
    7468496589
    5278635756
    3287952832
    7993992245
    5957959665
    6394862637
    """

    assert map_to_string(result) == expected
  end

  test "simulate_step - step 2 - flash!" do
    input = ~s"""
    6594254334
    3856965822
    6375667284
    7252447257
    7468496589
    5278635756
    3287952832
    7993992245
    5957959665
    6394862637
    """

    expected = ~s"""
    8807476555
    5089087054
    8597889608
    8485769600
    8700908800
    6600088989
    6800005943
    0000007456
    9000000876
    8700006848
    """

    result = simulate_step(parse_input(input))

    assert map_to_string(result) == expected
  end

  test "count_flashes_after_step - 10 steps" do
    assert count_flashes_after_step(parsed_sample_input(), 10) == 204
  end

  test "count_flashes_after_step - 100 steps" do
    assert count_flashes_after_step(parsed_sample_input(), 100) == 1656
  end

  test "find_first_step_all_flash" do
    assert find_first_step_all_flash(parsed_sample_input()) == 195
  end
end
