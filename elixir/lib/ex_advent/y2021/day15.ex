defmodule ExAdvent.Y2021.Day15 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_best_path(1)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_best_path(5)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day15")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def find_best_path(grid, grid_repetitions) do
    start_point = {0, 0}
    end_point = {grid_repetitions * length(Enum.at(grid, 0)) - 1, grid_repetitions * length(grid) - 1}

    options = [{start_point, 0}]
    visited = MapSet.new([start_point])

    Stream.iterate({options, visited}, fn {options, visited} ->
      lowest_score_point = Enum.min_by(options, fn {_, score} -> score end)
      options = List.delete(options, lowest_score_point)

      {point, score} = lowest_score_point

      neighbors =
        get_neighboring_points(point, end_point)
        |> Enum.filter(fn point -> !MapSet.member?(visited, point) end)

      Enum.reduce(neighbors, {options, visited}, fn {x, y}, {options, visited} ->
        risk_level = get_risk_level_for_point(grid, {x, y})
        score = score + risk_level

        options = [{{x, y}, score} | options]
        visited = MapSet.put(visited, {x, y})

        {options, visited}
      end)
    end)
    |> Stream.filter(fn {options, _} ->
      Enum.any?(options, fn {point, _} -> point == end_point end)
    end)
    |> Enum.take(1)
    |> then(fn [{options, _}] ->
      {_, score} = Enum.find(options, fn {point, _} -> point == end_point end)

      score
    end)
  end

  @spec get_neighboring_points({any, any}, {any, any}) :: list
  def get_neighboring_points({x, y}, {xend, yend}) do
    [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
    |> Enum.map(fn {xoff, yoff} -> {x + xoff, y + yoff} end)
    |> Enum.filter(fn {x, y} -> x >= 0 && x <= xend && y >= 0 && y <= yend end)
  end

  def get_risk_level_for_point(grid, {x, y}) do
    sector_size = length(grid)
    sector_x = floor(x / sector_size)
    sector_y = floor(y / sector_size)

    grid_x = rem(x, sector_size)
    grid_y = rem(y, sector_size)

    rem(Enum.at(Enum.at(grid, grid_y), grid_x) - 1 + sector_x + sector_y, 9) + 1
  end
end
