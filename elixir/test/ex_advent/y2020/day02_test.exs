defmodule ExAdvent.Y2020.Day02Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day02

  test "parse input" do
    input = ~s"""
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """

    assert parse_input(input) == [
             {1, 3, ?a, "abcde"},
             {1, 3, ?b, "cdefg"},
             {2, 9, ?c, "ccccccccc"}
           ]
  end

  test "parse_line" do
    assert parse_line("1-3 a: abcde") == {1, 3, ?a, "abcde"}
  end

  test "valid_old_co_password? - 1-3 a: abcde" do
    assert valid_old_co_password?({1, 3, ?a, "abcde"}) == true
  end

  test "valid_old_co_password? - 1-3 b: cdefg" do
    assert valid_old_co_password?({1, 3, ?b, "cdefg"}) == false
  end

  test "valid_old_co_password? - 2-9 c: ccccccccc" do
    assert valid_old_co_password?({2, 9, ?c, "ccccccccc"}) == true
  end

  test "valid_toboggan_password? - 1-3 a: abcde" do
    assert valid_toboggan_password?({1, 3, ?a, "abcde"}) == true
  end

  test "valid_toboggan_password? - 1-3 b: cdefg" do
    assert valid_toboggan_password?({1, 3, ?b, "cdefg"}) == false
  end

  test "valid_toboggan_password? - 2-9 c: ccccccccc" do
    assert valid_toboggan_password?({2, 9, ?c, "ccccccccc"}) == false
  end
end
