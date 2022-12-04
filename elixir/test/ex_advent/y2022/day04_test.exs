defmodule ExAdvent.Y2022.Day04Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day04

  def sample_input() do
    ~s"""
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == [
             {{2, 4}, {6, 8}},
             {{2, 3}, {4, 5}},
             {{5, 7}, {7, 9}},
             {{2, 8}, {3, 7}},
             {{6, 6}, {4, 6}},
             {{2, 6}, {4, 8}}
           ]
  end

  test "do_assignments_fully_overlap - no overlap" do
    assert do_assignments_fully_overlap({{2, 4}, {6, 8}}) == false
  end

  test "do_assignments_fully_overlap - partial overlap" do
    assert do_assignments_fully_overlap({{5, 7}, {7, 9}}) == false
  end

  test "do_assignments_fully_overlap - first within second" do
    assert do_assignments_fully_overlap({{6, 6}, {4, 6}}) == true
  end

  test "do_assignments_fully_overlap - second within first" do
    assert do_assignments_fully_overlap({{2, 8}, {3, 7}}) == true
  end

  test "do_assignments_partially_overlap - first lower than second" do
    assert do_assignments_partially_overlap({{2, 4}, {6, 8}}) == false
  end

  test "do_assignments_partially_overlap - first higher than second" do
    assert do_assignments_partially_overlap({{4, 5}, {6, 7}}) == false
  end

  test "do_assignments_partially_overlap - partial overlap" do
    assert do_assignments_partially_overlap({{5, 7}, {7, 9}}) == true
  end

  test "do_assignments_partially_overlap - first within second" do
    assert do_assignments_partially_overlap({{6, 6}, {4, 6}}) == true
  end

  test "do_assignments_partially_overlap - second within first" do
    assert do_assignments_partially_overlap({{2, 8}, {3, 7}}) == true
  end
end
