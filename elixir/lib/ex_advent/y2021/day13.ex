defmodule ExAdvent.Y2021.Day13 do
  def solve_part1 do
    input()
    |> parse_input()
    |> count_points_after_first_fold()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> simulate_folds()
    |> get_grid_string()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day13")
  end

  def parse_input(input) do
    [points, folds] =
      input
      |> String.trim()
      |> String.split("\n\n")

    points = parse_points(points)
    folds = parse_folds(folds)

    {points, folds}
  end

  defp parse_points(points) do
    points
    |> String.split("\n")
    |> Enum.map(fn point ->
      point
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  defp parse_folds(folds) do
    folds
    |> String.split("\n")
    |> Enum.map(fn fold ->
      result = Regex.named_captures(~r/^fold along (?<dir>.)=(?<num>\d+)$/, fold)

      dir = String.to_atom(result["dir"])
      num = String.to_integer(result["num"])

      {dir, num}
    end)
  end

  def count_points_after_first_fold({points, folds}) do
    [fold | _] = folds

    simulate_fold(points, fold)
    |> Enum.count()
  end

  def simulate_folds({points, folds}) do
    Enum.reduce(folds, points, fn fold, points ->
      simulate_fold(points, fold)
    end)
  end

  def simulate_fold(points, fold) do
    {fold_dir, fold_at} = fold

    case fold_dir do
      :x -> fold_horizontal(points, fold_at)
      :y -> fold_vertical(points, fold_at)
    end
  end

  defp fold_horizontal(points, fold_at) do
    points
    |> Enum.reduce([], fn {x, y}, points ->
      cond do
        x <= fold_at ->
          [{x, y} | points]

        true ->
          [{2 * fold_at - x, y} | points]
      end
    end)
    |> Enum.uniq()
  end

  defp fold_vertical(points, fold_at) do
    points
    |> Enum.reduce([], fn {x, y}, points ->
      cond do
        y <= fold_at ->
          [{x, y} | points]

        true ->
          [{x, 2 * fold_at - y} | points]
      end
    end)
    |> Enum.uniq()
  end

  def get_grid_string(points) do
    max_x =
      points
      |> Enum.map(&elem(&1, 0))
      |> Enum.max()

    max_y =
      points
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

    points_set = MapSet.new(points)

    str =
      0..max_y
      |> Enum.map(fn y ->
        0..max_x
        |> Enum.map(fn x ->
          cond do
            MapSet.member?(points_set, {x, y}) -> "#"
            true -> "."
          end
        end)
        |> Enum.join("")
      end)
      |> Enum.join("\n")

    str <> "\n"
  end
end
