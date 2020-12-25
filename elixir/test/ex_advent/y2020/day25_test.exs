defmodule ExAdvent.Y2020.Day25Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day25

  test "parse input" do
    input = ~s"""
    5764801
    17807724
    """

    assert parse_input(input) == [5_764_801, 17_807_724]
  end

  test "get_encryption_key" do
    assert get_encryption_key([5_764_801, 17_807_724]) == 14_897_079
  end

  test "get_loop_number - 5764801" do
    assert get_loop_number(5_764_801) == 8
  end

  test "get_loop_number - 17807724" do
    assert get_loop_number(17_807_724) == 11
  end

  test "transform_subject_number - 17807724" do
    assert transform_subject_number(17_807_724, 8) == 14_897_079
  end

  test "transform_subject_number - 5764801" do
    assert transform_subject_number(5_764_801, 11) == 14_897_079
  end
end
