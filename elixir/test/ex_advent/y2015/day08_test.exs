defmodule ExAdvent.Y2015.Day08Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day08

  test "replace_escaped_characters - " do
    assert replace_escaped_characters("") == ""
  end

  test "replace_escaped_characters - a" do
    assert replace_escaped_characters("a") == "a"
  end

  test "replace_escaped_characters - \\\\" do
    assert replace_escaped_characters("\\\\") == "?"
  end

  test "replace_escaped_characters - \\x43" do
    assert replace_escaped_characters("\\x23") == "?"
  end

  test "replace_escaped_characters - \\\"" do
    assert replace_escaped_characters("\\\"") == "?"
  end

  test "part1 - example1" do
    input = ["\"\""]

    assert part1(input) == 2
  end

  test "part1 - example" do
    input = ["\"\"", "\"abc\"", "\"aaa\\\"aaa\"", "\"\\x27\""]

    assert part1(input) == 12
  end

  test "encoded_character_count = \"\"" do
    assert encoded_character_count("\"\"") == 6
  end

  test "encoded_character_count = \"abc\"" do
    assert encoded_character_count("\"abc\"") == 9
  end

  test "encoded_character_count - \"aaa\\\"aaa\"" do
    assert encoded_character_count("\"aaa\\\"aaa\"") == 16
  end

  test "encoded_character_count - \"\\x27\"" do
    assert encoded_character_count("\"\\x27\"") == 11
  end

  test "part2 - example" do
    input = ["\"\"", "\"abc\"", "\"aaa\\\"aaa\"", "\"\\x27\""]

    assert part2(input) == 19
  end
end
