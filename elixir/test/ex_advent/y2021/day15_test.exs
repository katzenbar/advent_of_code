defmodule ExAdvent.Y2021.Day15Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day15

  def sample_input() do
    ~s"""
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == [
             [1, 1, 6, 3, 7, 5, 1, 7, 4, 2],
             [1, 3, 8, 1, 3, 7, 3, 6, 7, 2],
             [2, 1, 3, 6, 5, 1, 1, 3, 2, 8],
             [3, 6, 9, 4, 9, 3, 1, 5, 6, 9],
             [7, 4, 6, 3, 4, 1, 7, 1, 1, 1],
             [1, 3, 1, 9, 1, 2, 8, 1, 3, 7],
             [1, 3, 5, 9, 9, 1, 2, 4, 2, 1],
             [3, 1, 2, 5, 4, 2, 1, 6, 3, 9],
             [1, 2, 9, 3, 1, 3, 8, 5, 2, 1],
             [2, 3, 1, 1, 9, 4, 4, 5, 8, 1]
           ]
  end

  test "find_best_path - single grid repetition" do
    assert find_best_path(parsed_sample_input(), 1) == 40
  end

  test "find_best_path - five grid repetitions" do
    assert find_best_path(parsed_sample_input(), 5) == 315
  end

  test "get_risk_level_for_point - (2, 3)" do
    assert get_risk_level_for_point(parsed_sample_input(), {2, 3}) == 9
  end

  test "get_risk_level_for_point - (2, 13)" do
    assert get_risk_level_for_point(parsed_sample_input(), {2, 13}) == 1
  end

  test "get_risk_level_for_point - (12, 13)" do
    assert get_risk_level_for_point(parsed_sample_input(), {12, 13}) == 2
  end
end
