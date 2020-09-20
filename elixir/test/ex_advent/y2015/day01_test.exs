defmodule ExAdvent.Y2015.Day01Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day01

  test "(()) is 0" do
    assert part1("(())") == 0
  end

  test "()() is 0" do
    assert part1("()()") == 0
  end

  test "((( is 3" do
    assert part1("(((") == 3
  end

  test "(()(()( is 3" do
    assert part1("(()(()(") == 3
  end

  test "))((((( is 3" do
    assert part1("))(((((") == 3
  end

  test "()) is -1" do
    assert part1("())") == -1
  end

  test ")())()) is -3" do
    assert part1(")())())") == -3
  end

  test "part2 - ) is 1" do
    assert part2(")") == 1
  end

  test "part2 - ()()) is 5" do
    assert part2("()())(()))") == 5
  end
end
