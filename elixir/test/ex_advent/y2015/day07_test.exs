defmodule ExAdvent.Y2015.Day07Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day07

  def sample_input do
    ~s"""
    123 -> x
    456 -> y
    x AND y -> d
    x OR y -> e
    x LSHIFT 2 -> f
    y RSHIFT 2 -> g
    NOT x -> h
    NOT y -> i
    NOT d -> j
    """
  end

  test "parse_instruction - x AND y" do
    assert parse_instruction("x AND y") == {:and, "x", "y"}
  end

  test "parse_instruction - x OR y" do
    assert parse_instruction("x OR y") == {:or, "x", "y"}
  end

  test "parse_instruction - x LSHIFT 2" do
    assert parse_instruction("x LSHIFT 2") == {:lshift, "x", "2"}
  end

  test "parse_instruction - x RSHIFT 2" do
    assert parse_instruction("x RSHIFT 2") == {:rshift, "x", "2"}
  end

  test "parse_instruction - NOT x" do
    assert parse_instruction("NOT x") == {:not, "x"}
  end

  test "parse_instruction - 123" do
    assert parse_instruction("123") == {:value, "123"}
  end

  test "parse_instruction - ax" do
    assert parse_instruction("ax") == {:value, "ax"}
  end

  test "parse_instruction - lx" do
    assert parse_instruction("lx") == {:value, "lx"}
  end

  test "parse_line - constant" do
    input = "123 -> x"
    assert parse_line(input) == {"x", {:value, "123"}}
  end

  test "parse_line - x AND y -> d" do
    input = "x AND y -> d"
    assert parse_line(input) == {"d", {:and, "x", "y"}}
  end

  test "build_map" do
    input = ["123 -> x", "456 -> y", "x AND y -> d"]
    expected = %{"x" => {:value, "123"}, "y" => {:value, "456"}, "d" => {:and, "x", "y"}}

    assert build_map(input) == expected
  end

  test "signal_for_wire - d" do
    assert signal_for_wire(sample_input(), "d") === 72
  end

  test "signal_for_wire - e" do
    assert signal_for_wire(sample_input(), "e") === 507
  end

  test "signal_for_wire - f" do
    assert signal_for_wire(sample_input(), "f") === 492
  end

  test "signal_for_wire - g" do
    assert signal_for_wire(sample_input(), "g") === 114
  end

  test "signal_for_wire - h" do
    assert signal_for_wire(sample_input(), "h") === 65412
  end

  test "signal_for_wire - i" do
    assert signal_for_wire(sample_input(), "i") === 65079
  end

  test "signal_for_wire - x" do
    assert signal_for_wire(sample_input(), "x") === 123
  end

  test "signal_for_wire - y" do
    assert signal_for_wire(sample_input(), "y") === 456
  end

  test "signal_for_wire - j" do
    assert signal_for_wire(sample_input(), "j") === 65463
  end
end
