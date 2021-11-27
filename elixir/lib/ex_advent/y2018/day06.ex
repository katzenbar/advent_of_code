defmodule ExAdvent.Y2018.Day06 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_largest_area()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_area_near_points(10000)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2018/day06")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(", ")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn [a, b] -> {a, b} end)
  end

  def find_largest_area(points) do
    {min_x, max_x} =
      points
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    {min_y, max_y} =
      points
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max()

    point_grid =
      Enum.flat_map(min_y..max_y, fn y ->
        Enum.map(min_x..max_x, fn x ->
          [{d1, p1x, p1y} | [{d2, _, _} | _]] =
            Enum.map(
              points,
              fn {px, py} -> {abs(x - px) + abs(y - py), px, py} end
            )
            |> Enum.sort_by(&elem(&1, 0))

          if d1 == d2, do: {x, y, nil}, else: {x, y, {p1x, p1y}}
        end)
      end)

    # Find the points that would have infinite area, because they are touching
    # the edge of the grid. Also include nil, because we don't care about the
    # area of tie points.
    invalid_points =
      point_grid
      |> Enum.reduce(MapSet.new([nil]), fn {x, y, point}, acc ->
        cond do
          x == min_x || x == max_x || y == min_y || y == max_y ->
            MapSet.put(acc, point)

          true ->
            acc
        end
      end)

    # Calculate the areas for non-infinite points, and take the largest size
    point_grid
    |> Enum.reduce(%{}, fn {_, _, point}, acc ->
      cond do
        MapSet.member?(invalid_points, point) ->
          acc

        true ->
          Map.update(acc, point, 1, &(&1 + 1))
      end
    end)
    |> Map.values()
    |> Enum.max()
  end

  # There could easily be points near enough outside of the bounding box, but
  # our set of points and distances are not arranged that way so we take the
  # shortcut to bound the area considered by the min and max X and Y values seen.
  def find_area_near_points(points, distance) do
    {min_x, max_x} =
      points
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    {min_y, max_y} =
      points
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max()

    Enum.flat_map(min_y..max_y, fn y ->
      Enum.map(min_x..max_x, fn x ->
        points
        |> Enum.map(fn {px, py} -> abs(x - px) + abs(y - py) end)
        |> Enum.sum()
      end)
    end)
    |> Enum.count(&(&1 < distance))
  end
end
