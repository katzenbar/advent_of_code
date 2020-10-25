defmodule ExAdvent.Y2015.Day25Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day25

  test "parse input" do
    input =
      "To continue, please consult the code grid in the manual.  Enter the code at row 2947, column 3029."

    assert parse_input(input) == {2947, 3029}
  end

  test "coordinates_to_ordinal - 1, 1" do
    assert coordinates_to_ordinal({1, 1}) == 1
  end

  test "coordinates_to_ordinal - 2, 2" do
    assert coordinates_to_ordinal({2, 2}) == 5
  end

  test "coordinates_to_ordinal - 5, 2" do
    assert coordinates_to_ordinal({5, 2}) == 17
  end

  test "coordinates_to_ordinal - 2, 5" do
    assert coordinates_to_ordinal({2, 5}) == 20
  end

  test "get_nth_code - 2" do
    assert get_nth_code(2) == 31_916_031
  end

  test "get_nth_code - 19" do
    assert get_nth_code(19) == 7_981_243
  end
end
