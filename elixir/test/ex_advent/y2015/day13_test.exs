defmodule ExAdvent.Y2015.Day13Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day13

  def example_input do
    [
      "Alice would gain 54 happiness units by sitting next to Bob.",
      "Alice would lose 79 happiness units by sitting next to Carol.",
      "Alice would lose 2 happiness units by sitting next to David.",
      "Bob would gain 83 happiness units by sitting next to Alice.",
      "Bob would lose 7 happiness units by sitting next to Carol.",
      "Bob would lose 63 happiness units by sitting next to David.",
      "Carol would lose 62 happiness units by sitting next to Alice.",
      "Carol would gain 60 happiness units by sitting next to Bob.",
      "Carol would gain 55 happiness units by sitting next to David.",
      "David would gain 46 happiness units by sitting next to Alice.",
      "David would lose 7 happiness units by sitting next to Bob.",
      "David would gain 41 happiness units by sitting next to Carol."
    ]
  end

  test "parse_line - gain" do
    assert parse_line("Alice would gain 54 happiness units by sitting next to Bob.", %{}) ==
             %{["Alice", "Bob"] => 54}
  end

  test "parse_line - lose" do
    assert parse_line("Bob would lose 7 happiness units by sitting next to Carol.", %{}) ==
             %{["Bob", "Carol"] => -7}
  end

  test "score_seating_arrangements" do
    {names, conditions} = get_problem_description_pt1(example_input())
    assert score_seating_arrangements({names, conditions}) == 330
  end

  test "score_seating_arrangement" do
    conditions = Enum.reduce(example_input(), %{}, &parse_line/2)

    assert score_seating_arrangement(
             MapSet.new([
               ["Alice", "Bob"],
               ["Bob", "Carol"],
               ["Carol", "David"],
               ["David", "Alice"]
             ]),
             conditions
           ) == 330
  end
end
