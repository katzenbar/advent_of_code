defmodule ExAdvent.Y2021.Day21Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day21

  test "parse input" do
    input = ~s"""
    Player 1 starting position: 4
    Player 2 starting position: 8
    """

    assert parse_input(input) == [4, 8]
  end

  test "play_deterministic_dice - 20 target score" do
    assert play_deterministic_dice([4, 8], 20) == {15, 0, [{6, 20}, {6, 9}]}
  end

  test "play_deterministic_dice - 1000 target score" do
    assert play_deterministic_dice([4, 8], 1000) == {993, 0, [{10, 1000}, {3, 745}]}
  end

  test "get_next_position" do
    assert get_next_position(4, 6) == 10
  end

  test "get_losing_score_with_num_rolls" do
    assert get_losing_score_with_num_rolls({993, 0, [{10, 1000}, {3, 745}]}) == 739_785
  end

  test "play_quantum_dice" do
    assert play_quantum_dice([4, 8]) == [444_356_092_776_315, 341_960_390_180_808]
  end
end
