defmodule ExAdvent.Y2022.Day08 do
  def solve_part1 do
    input()
    |> parse_input()
    |> count_trees_visible_from_edges()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> get_highest_scenic_score()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day08")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn x ->
      x
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, yi}, tree_map ->
      row
      |> Enum.with_index()
      |> Enum.reduce(tree_map, fn {val, xi}, tree_map ->
        Map.put(tree_map, {xi, yi}, val)
      end)
    end)
  end

  def count_trees_visible_from_edges(tree_map) do
    tree_map
    |> Map.keys()
    |> Enum.count(fn coords -> is_tree_visible_from_edge(coords, tree_map) end)
  end

  def get_highest_scenic_score(tree_map) do
    tree_map
    |> Map.keys()
    |> Enum.map(fn coords -> scenic_score_from_coords(coords, tree_map) end)
    |> Enum.max()
  end

  def scenic_score_from_coords(coords, tree_map) do
    [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
    |> Enum.map(&count_trees_visible_from_coords_in_dir(coords, &1, tree_map))
    |> Enum.product()
  end

  def is_tree_visible_from_edge(coords, tree_map) do
    [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
    |> Enum.any?(&is_tree_visible_from_edge_in_dir(coords, &1, tree_map))
  end

  def is_tree_visible_from_edge_in_dir(coords, {xdelta, ydelta}, tree_map) do
    height = Map.get(tree_map, coords)

    coords
    |> Stream.iterate(fn {xi, yi} -> {xi + xdelta, yi + ydelta} end)
    # remove first element, which is our current coord
    |> Stream.drop(1)
    |> Stream.take_while(fn coords -> Map.has_key?(tree_map, coords) end)
    |> Enum.to_list()
    |> Enum.all?(fn check_coords -> Map.get(tree_map, check_coords) < height end)
  end

  def count_trees_visible_from_coords_in_dir(coords, {xdelta, ydelta}, tree_map) do
    start_height = Map.get(tree_map, coords)

    coords
    |> Stream.iterate(fn {xi, yi} -> {xi + xdelta, yi + ydelta} end)
    # remove first element, which is our current coord
    |> Stream.drop(1)
    |> Stream.take_while(fn coords -> Map.has_key?(tree_map, coords) end)
    |> Enum.to_list()
    |> Enum.reduce_while(0, fn coords, count ->
      height = Map.get(tree_map, coords)
      if height >= start_height, do: {:halt, count + 1}, else: {:cont, count + 1}
    end)
  end
end
