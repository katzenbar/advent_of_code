defmodule ExAdvent.Y2022.Day11Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day11

  def sample_input() do
    ~s"""
    Monkey 0:
      Starting items: 79, 98
      Operation: new = old * 19
      Test: divisible by 23
        If true: throw to monkey 2
        If false: throw to monkey 3

    Monkey 1:
      Starting items: 54, 65, 75, 74
      Operation: new = old + 6
      Test: divisible by 19
        If true: throw to monkey 2
        If false: throw to monkey 0

    Monkey 2:
      Starting items: 79, 60, 97
      Operation: new = old * old
      Test: divisible by 13
        If true: throw to monkey 1
        If false: throw to monkey 3

    Monkey 3:
      Starting items: 74
      Operation: new = old + 3
      Test: divisible by 17
        If true: throw to monkey 0
        If false: throw to monkey 1
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() ==
             %{
               0 => {[79, 98], {:old, :mul, 19}, 23, 2, 3, 0},
               1 => {[54, 65, 75, 74], {:old, :add, 6}, 19, 2, 0, 0},
               2 => {[79, 60, 97], {:old, :mul, :old}, 13, 1, 3, 0},
               3 => {[74], {:old, :add, 3}, 17, 0, 1, 0}
             }
  end

  test "simulate_round" do
    assert simulate_round(parsed_sample_input(), 3, 96577) ==
             %{
               0 => {[20, 23, 27, 26], {:old, :mul, 19}, 23, 2, 3, 2},
               1 => {[2080, 25, 167, 207, 401, 1046], {:old, :add, 6}, 19, 2, 0, 4},
               2 => {[], {:old, :mul, :old}, 13, 1, 3, 3},
               3 => {[], {:old, :add, 3}, 17, 0, 1, 5}
             }
  end

  test "simulate_rounds" do
    assert simulate_rounds(parsed_sample_input(), 3, 0, 20) == %{
             0 => {[10, 12, 14, 26, 34], {:old, :mul, 19}, 23, 2, 3, 101},
             1 => {[245, 93, 53, 199, 115], {:old, :add, 6}, 19, 2, 0, 95},
             2 => {[], {:old, :mul, :old}, 13, 1, 3, 7},
             3 => {[], {:old, :add, 3}, 17, 0, 1, 105}
           }
  end

  test "simulate_rounds - large" do
    assert simulate_rounds(parsed_sample_input(), 1, 96577, 1000) == %{
             0 => {[84464, 48934, 39396, 19275, 48307, 82374, 27591], {:old, :mul, 19}, 23, 2, 3, 5204},
             1 => {[12752, 69429, 31980], {:old, :add, 6}, 19, 2, 0, 4792},
             2 => {[], {:old, :mul, :old}, 13, 1, 3, 199},
             3 => {[], {:old, :add, 3}, 17, 0, 1, 5192}
           }
  end

  test "get_monkey_business" do
    assert get_monkey_business(parsed_sample_input(), 20) == 10605
  end

  test "get_monkey_business_with_lcd" do
    assert get_monkey_business_with_lcd(parsed_sample_input(), 10_000) == 2_713_310_158
  end
end
