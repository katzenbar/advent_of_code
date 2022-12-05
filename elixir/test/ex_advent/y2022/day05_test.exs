defmodule ExAdvent.Y2022.Day05Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day05

  def sample_input() do
    ~s"""
        [D]
    [N] [C]
    [Z] [M] [P]
     1   2   3

    move 1 from 2 to 1
    move 3 from 1 to 3
    move 2 from 2 to 1
    move 1 from 1 to 2
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() ==
             {[["N", "Z"], ["D", "C", "M"], ["P"]], [[1, 2, 1], [3, 1, 3], [2, 2, 1], [1, 1, 2]]}
  end

  test "move_crates_with_instruction - move 1" do
    assert move_crates_with_instruction([1, 2, 1], [["N", "Z"], ["D", "C", "M"], ["P"]], false) == [
             ["D", "N", "Z"],
             ["C", "M"],
             ["P"]
           ]
  end

  test "move crates - moving 2, cant move multiple" do
    assert move_crates_with_instruction([3, 1, 3], [["D", "N", "Z"], ["C", "M"], ["P"]], false) == [
             [],
             ["C", "M"],
             ["Z", "N", "D", "P"]
           ]
  end

  test "move crates - moving 2, can move multiple" do
    assert move_crates_with_instruction([3, 1, 3], [["D", "N", "Z"], ["C", "M"], ["P"]], true) == [
             [],
             ["C", "M"],
             ["D", "N", "Z", "P"]
           ]
  end

  test "move_crates, without moving multiple at once" do
    assert move_crates(parsed_sample_input(), false) == [["C"], ["M"], ["Z", "N", "D", "P"]]
  end

  test "move_crates, moving multiple at once" do
    assert move_crates(parsed_sample_input(), true) == [["M"], ["C"], ["D", "N", "Z", "P"]]
  end

  test "get_top_crates" do
    assert get_top_crates([["C"], ["M"], ["Z", "N", "D", "P"]]) == "CMZ"
  end
end
