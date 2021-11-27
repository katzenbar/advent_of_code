defmodule ExAdvent.Y2018.Day05Test do
  use ExUnit.Case

  import ExAdvent.Y2018.Day05

  test "parse input" do
    input = ~s"""
    dabAcCaCBAcCcaDA
    """

    assert parse_input(input) == "dabAcCaCBAcCcaDA"
  end

  test "simulate_polymer_reaction - dabAcCaCBAcCcaDA" do
    assert simulate_polymer_reaction("dabAcCaCBAcCcaDA") == "dabCBAcaDA"
  end

  test "find_most_improved_polymer - dabAcCaCBAcCcaDA" do
    assert find_most_improved_polymer("dabAcCaCBAcCcaDA") == "daDA"
  end
end
