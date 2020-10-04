defmodule ExAdvent.Y2015.Day21Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day21

  test "parse input" do
    input = ~s"""
    Hit Points: 104
    Damage: 8
    Armor: 1
    """

    assert parse_input(input) == {104, 8, 1}
  end

  test "player_wins_battle?" do
    player = {8, 5, 5}
    boss = {12, 7, 2}

    assert player_wins_battle?(player, boss) == true
  end

  test "pad_left - add a digit" do
    assert pad_left([1], 2, 0) == [0, 1]
  end

  test "pad_left - add some digits" do
    assert pad_left([1, 0], 4, 0) == [0, 0, 1, 0]
  end

  test "pad_left - already right number of digits" do
    assert pad_left([1, 0], 2, 0) == [1, 0]
  end

  test "pad_left - already too many digits" do
    assert pad_left([0, 1, 0], 2, 0) == [0, 1, 0]
  end

  test "pick_up_to" do
    list = [1, 2, 3, 4]

    assert pick_up_to(list, 2) == [
             [],
             [4],
             [3],
             [4, 3],
             [2],
             [4, 2],
             [3, 2],
             [1],
             [4, 1],
             [3, 1],
             [2, 1]
           ]
  end

  test "item_combi" do
    assert item_combinations() == []
  end
end
