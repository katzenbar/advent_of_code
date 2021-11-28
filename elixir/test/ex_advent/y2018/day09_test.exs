defmodule ExAdvent.Y2018.Day09Test do
  use ExUnit.Case

  import ExAdvent.Y2018.Day09

  test "parse input" do
    input = "10 players; last marble is worth 1618 points"
    assert parse_input(input) == {10, 1618}
  end

  test "get_winning_score - 9 players, 25 marbles" do
    assert get_winning_score({9, 25}) == 32
  end

  test "get_winning_score - 10 players, 1618 marbles" do
    assert get_winning_score({10, 1618}) == 8317
  end

  test "get_winning_score - 13 players, 7999 marbles" do
    assert get_winning_score({13, 7999}) == 146_373
  end

  test "get_winning_score - 30 players, 5807 marbles" do
    assert get_winning_score({30, 5807}) == 37305
  end
end
