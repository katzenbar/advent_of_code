defmodule ExAdvent.Y2016.Day05Test do
  use ExUnit.Case

  import ExAdvent.Y2016.Day05

  test "parse input" do
    input = ""
    assert parse_input(input) == ""
  end

  test "hash - abc3231929" do
    assert hash("abc3231929") == "00000155f8105dff7f56ee10fa9b9abd"
  end

  test "password_character - 00000155f8105dff7f56ee10fa9b9abd" do
    assert password_character("00000155f8105dff7f56ee10fa9b9abd") == "1"
  end

  test "password_character - 00100155f8105dff7f56ee10fa9b9abd" do
    assert password_character("00100155f8105dff7f56ee10fa9b9abd") == nil
  end

  test "password_for_door_pt1 - abc" do
    assert password_for_door_pt1("abc") == "18f47a30"
  end

  @tag timeout: :infinity
  test "password_for_door_pt2 - abc" do
    assert password_for_door_pt2("abc") == "05ace8e3"
  end
end
