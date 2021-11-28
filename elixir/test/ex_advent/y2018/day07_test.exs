defmodule ExAdvent.Y2018.Day07Test do
  use ExUnit.Case

  import ExAdvent.Y2018.Day07

  def example_dependencies,
    do: [
      {"C", "A"},
      {"C", "F"},
      {"A", "B"},
      {"A", "D"},
      {"B", "E"},
      {"D", "E"},
      {"F", "E"}
    ]

  test "parse input" do
    input = ~s"""
    Step C must be finished before step A can begin.
    Step C must be finished before step F can begin.
    Step A must be finished before step B can begin.
    Step A must be finished before step D can begin.
    Step B must be finished before step E can begin.
    Step D must be finished before step E can begin.
    Step F must be finished before step E can begin.
    """

    assert parse_input(input) == example_dependencies()
  end

  test "build_dependency_graph" do
    expected = %{
      "A" => MapSet.new(["C"]),
      "B" => MapSet.new(["A"]),
      "C" => MapSet.new(),
      "D" => MapSet.new(["A"]),
      "E" => MapSet.new(["B", "D", "F"]),
      "F" => MapSet.new(["C"])
    }

    assert build_dependency_graph(example_dependencies()) == expected
  end

  test "get_instruction_order" do
    assert get_instruction_order(example_dependencies()) == "CABDFE"
  end

  test "simulate_construction" do
    assert simulate_construction(example_dependencies(), 2, 0) == 15
  end

  test "task_length - C" do
    assert task_length("C", 20) == 23
  end

  test "task_length - A" do
    assert task_length("A", 0) == 1
  end
end
