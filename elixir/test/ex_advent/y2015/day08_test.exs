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
end
