defmodule ExAdvent.Y2020.Day23Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day23

  test "parse input" do
    input = ~s"""
    389125467
    """

    assert parse_input(input) == [3, 8, 9, 1, 2, 5, 4, 6, 7]
  end

  test "perform_moves - 389125467" do
    result =
      [3, 8, 9, 1, 2, 5, 4, 6, 7]
      |> perform_moves(10)
      |> find_labels_after_one()

    assert result == "92658374"
  end

  test "perform_moves - 100 times" do
    result =
      [3, 8, 9, 1, 2, 5, 4, 6, 7]
      |> perform_moves(100)
      |> find_labels_after_one()

    assert result == "67384529"
  end

  test "find_destination_cup - easy" do
    assert find_destination_cup(3, [2, 5, 4, 6, 7], [8, 9, 1]) == 2
  end

  test "find_destination_cup - has to skip a number" do
    assert find_destination_cup(3, [5, 4, 6, 7, 1], [8, 9, 2]) == 1
  end

  test "find_destination_cup - wrapping around" do
    assert find_destination_cup(3, [5, 4, 6, 7], [8, 2, 1]) == 7
  end

  test "add_more_cups" do
    assert add_more_cups([3, 8, 9, 1, 2, 5, 4, 6, 7], 15) == %{
             1 => 2,
             2 => 5,
             3 => 8,
             4 => 6,
             5 => 4,
             6 => 7,
             7 => 10,
             8 => 9,
             9 => 1,
             10 => 11,
             11 => 12,
             12 => 13,
             13 => 14,
             14 => 15,
             15 => 3
           }
  end
end
