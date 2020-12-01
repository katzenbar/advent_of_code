defmodule ExAdvent.Y2016.Day10Test do
  use ExUnit.Case

  import ExAdvent.Y2016.Day10

  test "parse input" do
    input = ~s"""
    value 5 goes to bot 2
    bot 2 gives low to bot 1 and high to bot 0
    value 3 goes to bot 1
    bot 1 gives low to output 1 and high to bot 0
    bot 0 gives low to output 2 and high to output 0
    value 2 goes to bot 2
    """

    assert parse_input(input) == %{
             "bot2" => [{:value, "2"}, {:value, "5"}],
             "bot1" => [{:value, "3"}, {:bot_low, "2"}],
             "bot0" => [{:bot_high, "1"}, {:bot_high, "2"}],
             "output0" => [{:bot_high, "0"}],
             "output1" => [{:bot_low, "1"}],
             "output2" => [{:bot_low, "0"}]
           }
  end

  test "resolve_values" do
    state = %{
      "bot2" => [{:value, "2"}, {:value, "5"}],
      "bot1" => [{:value, "3"}, {:bot_low, "2"}],
      "bot0" => [{:bot_high, "1"}, {:bot_high, "2"}],
      "output0" => [{:bot_high, "0"}],
      "output1" => [{:bot_low, "1"}],
      "output2" => [{:bot_low, "0"}]
    }

    assert resolve_values("output0", state) == [{:value, "5"}]
  end

  test "find_target_comparison" do
    state = %{
      "bot2" => [{:value, "2"}, {:value, "5"}],
      "bot1" => [{:value, "3"}, {:bot_low, "2"}],
      "bot0" => [{:bot_high, "1"}, {:bot_high, "2"}],
      "output0" => [{:bot_high, "0"}],
      "output1" => [{:bot_low, "1"}],
      "output2" => [{:bot_low, "0"}]
    }

    assert find_target_comparison(state, ["2", "3"]) == "bot1"
  end
end
