defmodule ExAdvent.Y2021.Day17Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day17

  test "parse input" do
    input = "target area: x=20..30, y=-10..-5"

    assert parse_input(input) == %{
             min_x: 20,
             max_x: 30,
             min_y: -10,
             max_y: -5
           }
  end

  test "point_could_hit_target - before target" do
    assert point_could_hit_target({10, 0}, %{min_x: 20, max_x: 30, min_y: -10, max_y: -5}) == true
  end

  test "point_could_hit_target - in target" do
    assert point_could_hit_target({25, -8}, %{min_x: 20, max_x: 30, min_y: -10, max_y: -5}) == false
  end

  test "point_could_hit_target - beyond X" do
    assert point_could_hit_target({31, -8}, %{min_x: 20, max_x: 30, min_y: -10, max_y: -5}) == false
  end

  test "point_could_hit_target - beyond Y" do
    assert point_could_hit_target({21, -11}, %{min_x: 20, max_x: 30, min_y: -10, max_y: -5}) == false
  end

  test "simulate_launch - 7,2 - hit" do
    assert simulate_launch({7, 2}, %{min_x: 20, max_x: 30, min_y: -10, max_y: -5}) == %{
             position: {28, -7},
             velocity: {0, -5},
             previous_positions: [{27, -3}, {25, 0}, {22, 2}, {18, 3}, {13, 3}, {7, 2}, {0, 0}]
           }
  end

  test "simulate_launch - 6,3 - hit" do
    assert simulate_launch({6, 3}, %{min_x: 20, max_x: 30, min_y: -10, max_y: -5}) == %{
             position: {21, -9},
             velocity: {0, -6},
             previous_positions: [{21, -4}, {21, 0}, {21, 3}, {20, 5}, {18, 6}, {15, 6}, {11, 5}, {6, 3}, {0, 0}]
           }
  end

  test "simulate_launch - 9,0 - hit" do
    assert simulate_launch({9, 0}, %{min_x: 20, max_x: 30, min_y: -10, max_y: -5}) == %{
             position: {30, -6},
             velocity: {5, -4},
             previous_positions: [{24, -3}, {17, -1}, {9, 0}, {0, 0}]
           }
  end

  test "simulate_launch - 17,-4 - miss" do
    assert simulate_launch({17, -4}, %{min_x: 20, max_x: 30, min_y: -10, max_y: -5}) == %{
             position: {33, -9},
             velocity: {15, -6},
             previous_positions: [{17, -4}, {0, 0}]
           }
  end

  test "simulate_launch - 5,3 - miss" do
    assert simulate_launch({5, 3}, %{min_x: 20, max_x: 30, min_y: -10, max_y: -5}) == %{
             position: {15, -15},
             previous_positions: [
               {15, -9},
               {15, -4},
               {15, 0},
               {15, 3},
               {15, 5},
               {14, 6},
               {12, 6},
               {9, 5},
               {5, 3},
               {0, 0}
             ],
             velocity: {0, -7}
           }
  end

  test "find_max_vertical_velocity" do
    assert find_max_vertical_velocity(%{min_x: 20, max_x: 30, min_y: -10, max_y: -5}) == 45
  end

  test "count_possible_initial_velocities" do
    assert count_possible_initial_velocities(%{min_x: 20, max_x: 30, min_y: -10, max_y: -5}) == 112
  end
end
