defmodule ExAdvent.Y2020.Day22Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day22

  test "parse input" do
    assert example_input() == [[9, 2, 6, 3, 1], [5, 8, 4, 7, 10]]
  end

  test "play_crab_combat" do
    assert play_crab_combat(example_input()) == [[], [3, 2, 10, 6, 8, 5, 9, 4, 7, 1]]
  end

  test "calculate_winner_score" do
    decks = [3, 2, 10, 6, 8, 5, 9, 4, 7, 1]
    assert calculate_winner_score(decks) == 306
  end

  test "play_recursive_combat" do
    assert play_recursive_combat(example_input()) == [[], [7, 5, 6, 2, 4, 1, 10, 8, 9, 3]]
  end

  test "play_recursive_combat - doesnt go on forever" do
    input =
      ~s"""
      Player 1:
      43
      19

      Player 2:
      2
      29
      14
      """
      |> parse_input()

    assert play_recursive_combat(input) == [[43, 19], []]
  end

  def example_input do
    input = ~s"""
    Player 1:
    9
    2
    6
    3
    1

    Player 2:
    5
    8
    4
    7
    10
    """

    parse_input(input)
  end
end
