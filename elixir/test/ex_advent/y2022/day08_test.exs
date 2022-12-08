defmodule ExAdvent.Y2022.Day08Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day08

  def sample_input() do
    ~s"""
    30373
    25512
    65332
    33549
    35390
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == %{
             {0, 0} => 3,
             {0, 1} => 2,
             {0, 2} => 6,
             {0, 3} => 3,
             {0, 4} => 3,
             {1, 0} => 0,
             {1, 1} => 5,
             {1, 2} => 5,
             {1, 3} => 3,
             {1, 4} => 5,
             {2, 0} => 3,
             {2, 1} => 5,
             {2, 2} => 3,
             {2, 3} => 5,
             {2, 4} => 3,
             {3, 0} => 7,
             {3, 1} => 1,
             {3, 2} => 3,
             {3, 3} => 4,
             {3, 4} => 9,
             {4, 0} => 3,
             {4, 1} => 2,
             {4, 2} => 2,
             {4, 3} => 9,
             {4, 4} => 0
           }
  end

  test "is_tree_visible_from_edge_in_dir - left" do
    assert is_tree_visible_from_edge_in_dir({1, 1}, {-1, 0}, parsed_sample_input()) == true
  end

  test "is_tree_visible_from_edge_in_dir - bottom" do
    assert is_tree_visible_from_edge_in_dir({1, 1}, {0, 1}, parsed_sample_input()) == false
  end

  test "is_tree_visible_from_edge - second 5" do
    assert is_tree_visible_from_edge({2, 1}, parsed_sample_input()) == true
  end

  test "is_tree_visible_from_edge - middle 3" do
    assert is_tree_visible_from_edge({2, 2}, parsed_sample_input()) == false
  end

  test "count_trees_visible_from_edges" do
    assert count_trees_visible_from_edges(parsed_sample_input()) == 21
  end

  test "count_trees_visible_from_coords_in_dir - 2, 1 looking right" do
    assert count_trees_visible_from_coords_in_dir({2, 1}, {1, 0}, parsed_sample_input()) == 2
  end

  test "count_trees_visible_from_coords_in_dir - 2, 1 looking left" do
    assert count_trees_visible_from_coords_in_dir({2, 1}, {-1, 0}, parsed_sample_input()) == 1
  end

  test "count_trees_visible_from_coords_in_dir - 2, 3 looking left" do
    assert count_trees_visible_from_coords_in_dir({2, 3}, {-1, 0}, parsed_sample_input()) == 2
  end

  test "scenic_score_from_coords, 2, 1" do
    assert scenic_score_from_coords({2, 1}, parsed_sample_input()) == 4
  end

  test "scenic_score_from_coords, 2, 3" do
    assert scenic_score_from_coords({2, 3}, parsed_sample_input()) == 8
  end

  test "scenic_score_from_coords, 3, 2" do
    assert scenic_score_from_coords({3, 2}, parsed_sample_input()) == 2
  end

  test "get_highest_scenic_score" do
    assert get_highest_scenic_score(parsed_sample_input()) == 8
  end
end
