defmodule ExAdvent.Y2022.Day09Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day09

  def sample_input() do
    ~s"""
    R 4
    U 4
    L 3
    D 1
    R 4
    D 1
    L 5
    R 2
    """
  end

  def larger_sample_input() do
    ~s"""
    R 5
    U 8
    L 8
    D 3
    R 17
    D 10
    L 25
    U 20
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == [{"R", 4}, {"U", 4}, {"L", 3}, {"D", 1}, {"R", 4}, {"D", 1}, {"L", 5}, {"R", 2}]
  end

  test "move_tail - same" do
    assert move_tail({4, 4}, {4, 4}) == {4, 4}
  end

  test "move_tail - still left" do
    assert move_tail({3, 4}, {4, 4}) == {4, 4}
  end

  test "move_tail - still right" do
    assert move_tail({5, 4}, {4, 4}) == {4, 4}
  end

  test "move_tail - still up" do
    assert move_tail({4, 5}, {4, 4}) == {4, 4}
  end

  test "move_tail - still down" do
    assert move_tail({4, 3}, {4, 4}) == {4, 4}
  end

  test "move_tail - still up-right" do
    assert move_tail({5, 5}, {4, 4}) == {4, 4}
  end

  test "move_tail - still up-left" do
    assert move_tail({3, 5}, {4, 4}) == {4, 4}
  end

  test "move_tail - still down-right" do
    assert move_tail({5, 3}, {4, 4}) == {4, 4}
  end

  test "move_tail - still down-left" do
    assert move_tail({3, 3}, {4, 4}) == {4, 4}
  end

  test "move_tail - left" do
    assert move_tail({2, 4}, {4, 4}) == {3, 4}
  end

  test "move_tail - right" do
    assert move_tail({4, 4}, {2, 4}) == {3, 4}
  end

  test "move_tail - up" do
    assert move_tail({4, 3}, {4, 1}) == {4, 2}
  end

  test "move_tail - down" do
    assert move_tail({4, 5}, {4, 7}) == {4, 6}
  end

  test "move_tail - up-right" do
    assert move_tail({6, 7}, {5, 5}) == {6, 6}
  end

  test "move_tail - up-left" do
    assert move_tail({4, 7}, {5, 5}) == {4, 6}
  end

  test "move_tail - down-right" do
    assert move_tail({6, 3}, {5, 5}) == {6, 4}
  end

  test "move_tail - down-left" do
    assert move_tail({4, 3}, {5, 5}) == {4, 4}
  end

  test "move_tail - right-up" do
    assert move_tail({7, 6}, {5, 5}) == {6, 6}
  end

  test "move_tail - left-up" do
    assert move_tail({3, 6}, {5, 5}) == {4, 6}
  end

  test "move_tail - right-down" do
    assert move_tail({7, 4}, {5, 5}) == {6, 4}
  end

  test "move_tail - left-down" do
    assert move_tail({3, 4}, {5, 5}) == {4, 4}
  end

  test "count_visited_locations - one link" do
    assert count_visited_locations(parsed_sample_input(), 1) == 13
  end

  test "count_visited_locations - nine links" do
    assert count_visited_locations(parsed_sample_input(), 9) == 1
  end

  test "count_visited_locations - nine links longer" do
    assert count_visited_locations(parse_input(larger_sample_input()), 9) == 36
  end

  test "simulate_steps - one link" do
    assert simulate_steps(parsed_sample_input(), 1) |> Enum.to_list() |> List.last() == {[], {2, 2}, [{1, 2}]}
  end

  test "simulate_steps - nine links" do
    assert simulate_steps(parsed_sample_input(), 9) |> Enum.to_list() |> List.last() ==
             {[], {2, 2}, [{1, 2}, {2, 2}, {3, 2}, {2, 2}, {1, 1}, {0, 0}, {0, 0}, {0, 0}, {0, 0}]}
  end

  test "simulate_steps - nine links longer" do
    assert simulate_steps(parse_input(larger_sample_input()), 9) |> Enum.to_list() |> List.last() ==
             {[], {-11, 15},
              [{-11, 14}, {-11, 13}, {-11, 12}, {-11, 11}, {-11, 10}, {-11, 9}, {-11, 8}, {-11, 7}, {-11, 6}]}
  end
end
