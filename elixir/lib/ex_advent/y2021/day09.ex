defmodule ExAdvent.Y2021.Day09 do
  def solve_part1 do
    input()
    |> parse_input()
    |> sum_risk_levels()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> multiply_largest_basins_size()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day09")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split("")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def sum_risk_levels(height_map_lists) do
    height_map = convert_height_map_from_list_to_map(height_map_lists)
    low_points = find_low_points(height_map)

    low_points
    |> Enum.map(&(Map.get(height_map, &1) + 1))
    |> Enum.sum()
  end

  def multiply_largest_basins_size(height_map_lists) do
    height_map_lists
    |> find_basins()
    |> Enum.map(&MapSet.size/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(&*/2)
  end

  def find_basins(height_map_lists) do
    height_map = convert_height_map_from_list_to_map(height_map_lists)
    low_points = find_low_points(height_map)

    low_points
    |> Enum.map(&find_basin(&1, height_map))
  end

  defp find_low_points(height_map) do
    height_map
    |> Map.keys()
    |> Enum.filter(&is_low_point(&1, height_map))
  end

  def convert_height_map_from_list_to_map(height_map_lists) do
    Enum.reduce(Enum.with_index(height_map_lists), %{}, fn {row, row_idx}, map ->
      Enum.reduce(Enum.with_index(row), map, fn {val, column_idx}, map ->
        Map.put(map, "#{column_idx},#{row_idx}", val)
      end)
    end)
  end

  defp is_low_point(position, height_map) do
    value = Map.get(height_map, position)

    [col_idx, row_idx] =
      position
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    Enum.all?([[-1, 0], [1, 0], [0, -1], [0, 1]], fn [col_off, row_off] ->
      key = "#{col_idx + col_off},#{row_idx + row_off}"
      neighbor_value = Map.get(height_map, key, 10)
      value < neighbor_value
    end)
  end

  def find_basin(point, height_map, basin_points_set \\ MapSet.new()) do
    value = Map.get(height_map, point)

    [col_idx, row_idx] =
      point
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    cond do
      value == 9 || value == nil ->
        basin_points_set

      MapSet.member?(basin_points_set, point) ->
        basin_points_set

      true ->
        basin_points_set = MapSet.put(basin_points_set, point)

        [[-1, 0], [1, 0], [0, -1], [0, 1]]
        |> Enum.reduce(basin_points_set, fn [col_off, row_off], basin_points_set ->
          key = "#{col_idx + col_off},#{row_idx + row_off}"
          find_basin(key, height_map, basin_points_set)
        end)
    end
  end
end
