defmodule ExAdvent.Y2015.Day18 do
  def solve_part1 do
    grid = input() |> parse_input()

    1..100
    |> Enum.reduce(grid, fn _, g -> get_next_grid(g) end)
    |> Map.values()
    |> Enum.sum()
    |> IO.puts()
  end

  def solve_part2 do
    grid =
      input()
      |> parse_input()
      |> Map.put({0, 0}, 1)
      |> Map.put({0, 99}, 1)
      |> Map.put({99, 0}, 1)
      |> Map.put({99, 99}, 1)

    1..100
    |> Enum.reduce(grid, fn _, g -> get_next_grid_pt2(g) end)
    |> Map.values()
    |> Enum.sum()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day18")
    |> String.trim()
    |> String.split("\n")
  end

  def parse_input(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, i}, x ->
      row
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.reduce(x, fn {char, j}, y ->
        val = if char == ?\#, do: 1, else: 0
        Map.put(y, {i, j}, val)
      end)
    end)
  end

  def get_next_grid(grid) do
    grid
    |> Map.keys()
    |> Enum.reduce(%{}, fn coords, next_grid ->
      Map.put(next_grid, coords, get_next_light_state(coords, grid))
    end)
  end

  def get_next_light_state(coords, grid) do
    case Map.get(grid, coords) do
      1 -> get_next_light_state(:on, coords, grid)
      0 -> get_next_light_state(:off, coords, grid)
    end
  end

  def get_next_light_state(:on, coords, grid) do
    on_neighbor_count =
      get_neighbor_coords(coords)
      |> Enum.map(fn neighbor -> Map.get(grid, neighbor, 0) end)
      |> Enum.sum()

    case on_neighbor_count do
      2 -> 1
      3 -> 1
      _ -> 0
    end
  end

  def get_next_light_state(:off, coords, grid) do
    on_neighbor_count =
      get_neighbor_coords(coords)
      |> Enum.map(fn neighbor -> Map.get(grid, neighbor, 0) end)
      |> Enum.sum()

    case on_neighbor_count do
      3 -> 1
      _ -> 0
    end
  end

  def get_neighbor_coords({x, y}) do
    [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]
    |> Enum.map(fn {a, b} -> {x + a, y + b} end)
  end

  def get_next_grid_pt2(grid) do
    grid
    |> Map.keys()
    |> Enum.reduce(%{}, fn coords, next_grid ->
      Map.put(next_grid, coords, get_next_light_state_pt2(coords, grid))
    end)
  end

  def get_next_light_state_pt2({0, 0}, _) do
    1
  end

  def get_next_light_state_pt2({0, 99}, _) do
    1
  end

  def get_next_light_state_pt2({99, 0}, _) do
    1
  end

  def get_next_light_state_pt2({99, 99}, _) do
    1
  end

  def get_next_light_state_pt2(coords, grid) do
    case Map.get(grid, coords) do
      1 -> get_next_light_state_pt2(:on, coords, grid)
      0 -> get_next_light_state_pt2(:off, coords, grid)
    end
  end

  def get_next_light_state_pt2(:on, coords, grid) do
    on_neighbor_count =
      get_neighbor_coords(coords)
      |> Enum.map(fn neighbor -> Map.get(grid, neighbor, 0) end)
      |> Enum.sum()

    case on_neighbor_count do
      2 -> 1
      3 -> 1
      _ -> 0
    end
  end

  def get_next_light_state_pt2(:off, coords, grid) do
    on_neighbor_count =
      get_neighbor_coords(coords)
      |> Enum.map(fn neighbor -> Map.get(grid, neighbor, 0) end)
      |> Enum.sum()

    case on_neighbor_count do
      3 -> 1
      _ -> 0
    end
  end
end
