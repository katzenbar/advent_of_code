defmodule ExAdvent.Y2020.Day05Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day05

  # BFFFBBFRRR: row 70, column 7, seat ID 567.
  # FFFBBBFRRR: row 14, column 7, seat ID 119.
  # BBFFBBFRLL: row 102, column 4, seat ID 820.

  test "parse input" do
    input = ~s"""
    BFFFBBFRRR
    FFFBBBFRRR
    BBFFBBFRLL
    """

    assert parse_input(input) == ["BFFFBBFRRR", "FFFBBBFRRR", "BBFFBBFRLL"]
  end

  test "find_seat_position - BFFFBBFRRR" do
    assert find_seat_position("BFFFBBFRRR") == {70, 7}
  end

  test "find_seat_position - FFFBBBFRRR" do
    assert find_seat_position("FFFBBBFRRR") == {14, 7}
  end

  test "find_seat_position - BBFFBBFRLL" do
    assert find_seat_position("BBFFBBFRLL") == {102, 4}
  end

  test "find_seat_id - BFFFBBFRRR" do
    assert find_seat_id("BFFFBBFRRR") == 567
  end

  test "find_seat_id - FFFBBBFRRR" do
    assert find_seat_id("FFFBBBFRRR") == 119
  end

  test "find_seat_id - BBFFBBFRLL" do
    assert find_seat_id("BBFFBBFRLL") == 820
  end

  test "find_empty_seat" do
    ids = [4, 7, 9, 5, 6]

    assert find_empty_seat(ids) == 8
  end
end
