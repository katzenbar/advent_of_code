defmodule ExAdvent.Y2020.Day06Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day06

  test "parse input" do
    input = ~s"""
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """

    assert parse_input(input) == [
             ['abc'],
             ['a', 'b', 'c'],
             ['ab', 'ac'],
             ['a', 'a', 'a', 'a'],
             ['b']
           ]
  end

  test "count_anyone_answered - ['abc']" do
    assert count_anyone_answered(['abc']) == 3
  end

  test "count_anyone_answered - ['a', 'b', 'c']" do
    assert count_anyone_answered(['a', 'b', 'c']) == 3
  end

  test "count_anyone_answered - ['ab', 'ac']" do
    assert count_anyone_answered(['ab', 'ac']) == 3
  end

  test "count_anyone_answered - ['a', 'a', 'a', 'a']" do
    assert count_anyone_answered(['a', 'a', 'a', 'a']) == 1
  end

  test "count_anyone_answered - ['b']" do
    assert count_anyone_answered(['b']) == 1
  end

  test "count_everyone_answered - ['abc']" do
    assert count_everyone_answered(['abc']) == 3
  end

  test "count_everyone_answered - ['a', 'b', 'c']" do
    assert count_everyone_answered(['a', 'b', 'c']) == 0
  end

  test "count_everyone_answered - ['ab', 'ac']" do
    assert count_everyone_answered(['ab', 'ac']) == 1
  end

  test "count_everyone_answered - ['a', 'a', 'a', 'a']" do
    assert count_everyone_answered(['a', 'a', 'a', 'a']) == 1
  end

  test "count_everyone_answered - ['b']" do
    assert count_everyone_answered(['b']) == 1
  end
end
