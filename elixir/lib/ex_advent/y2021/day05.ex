defmodule ExAdvent.Y2021.Day05 do
  def solve_part1 do
    input()
    |> parse_input()
    |> filter_to_horizontal_and_vertical_lines()
    |> count_points_with_overlaps()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> count_points_with_overlaps()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day05")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(input_line) do
    input_line
    |> String.split(" -> ")
    |> Enum.map(fn point ->
      point
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def count_points_with_overlaps(lines) do
    covered_points = count_covered_points(lines)

    covered_points
    |> Map.values()
    |> Enum.count(&(&1 > 1))
  end

  def filter_to_horizontal_and_vertical_lines(lines) do
    Enum.filter(lines, fn [[x1, y1], [x2, y2]] ->
      x1 == x2 || y1 == y2
    end)
  end

  def count_covered_points(lines) do
    Enum.reduce(lines, %{}, fn [[x1, y1], [x2, y2]], covered_points ->
      cond do
        x1 == x2 ->
          y1..y2
          |> Enum.reduce(covered_points, fn y, covered_points ->
            Map.update(covered_points, "#{x1},#{y}", 1, &(&1 + 1))
          end)

        true ->
          slope = (y2 - y1) * 1.0 / (x2 - x1)
          intercept = y1 - slope * x1

          x1..x2
          |> Enum.reduce(covered_points, fn x, covered_points ->
            y = slope * x + intercept
            y = trunc(y)
            Map.update(covered_points, "#{x},#{y}", 1, &(&1 + 1))
          end)
      end
    end)
  end

  def display_map(lines, covered_points) do
    IO.puts("\n\n============")
    flattened_points = Enum.flat_map(lines, & &1)
    {min_x, max_x} = Enum.min_max(Enum.map(flattened_points, &Enum.at(&1, 0)))
    {min_y, max_y} = Enum.min_max(Enum.map(flattened_points, &Enum.at(&1, 1)))

    min_y..max_y
    |> Enum.map(fn y ->
      min_x..max_x
      |> Enum.map(fn x ->
        Map.get(covered_points, "#{x},#{y}", ".")
      end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
    |> IO.puts()

    IO.puts("============\n")
  end
end
