defmodule ExAdvent.Y2022.Day18Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day18

  def sample_input() do
    ~s"""
    2,2,2
    1,2,2
    3,2,2
    2,1,2
    2,3,2
    2,2,1
    2,2,3
    2,2,4
    2,2,6
    1,2,5
    3,2,5
    2,1,5
    2,3,5
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() ==
             MapSet.new([
               {1, 2, 2},
               {1, 2, 5},
               {2, 1, 2},
               {2, 1, 5},
               {2, 2, 1},
               {2, 2, 2},
               {2, 2, 3},
               {2, 2, 4},
               {2, 2, 6},
               {2, 3, 2},
               {2, 3, 5},
               {3, 2, 2},
               {3, 2, 5}
             ])
  end

  test "count_total_non_touching_faces" do
    assert count_total_non_touching_faces(parsed_sample_input()) == 64
  end

  test "count_exterior_faces" do
    assert count_exterior_faces(parsed_sample_input()) == 58
  end

  test "find_bounding_box" do
    assert find_bounding_box(parsed_sample_input()) == {{0, 0, 0}, {4, 4, 7}}
  end
end
