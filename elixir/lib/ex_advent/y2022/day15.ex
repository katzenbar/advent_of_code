defmodule ExAdvent.Y2022.Day15 do
  def solve_part1 do
    input()
    |> parse_input()
    |> count_impossible_pos_in_row(2_000_000)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_beacon_tuning_freq(4_000_000)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day15")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [sx, sy, bx, by] =
        line
        |> String.replace(~r/[^-\d,:]/, "")
        |> String.split(~r/[,:]/)
        |> Enum.map(&String.to_integer/1)

      {{sx, sy}, {bx, by}, manhattan_dist({sx, sy}, {bx, by})}
    end)
  end

  def manhattan_dist({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

  def count_impossible_pos_in_row(sensors, y) do
    beacon_set =
      Enum.filter(sensors, fn {_, {_, by}, _} -> by == y end) |> Enum.map(fn {_, {bx, _}, _} -> bx end) |> MapSet.new()

    sensors
    |> Enum.reduce(MapSet.new(), fn {{sx, sy}, _, beacon_dist}, visited_set ->
      xdelta = beacon_dist - abs(sy - y)

      if xdelta >= 0,
        do: MapSet.union(visited_set, MapSet.new((sx - xdelta)..(sx + xdelta))),
        else: visited_set
    end)
    |> MapSet.difference(beacon_set)
    |> MapSet.size()
  end

  def find_beacon_tuning_freq(sensors, grid_limit) do
    {x, y} =
      Stream.map(0..grid_limit, fn y ->
        [start | rest] =
          sensors
          |> Enum.map(fn {{sx, sy}, _, beacon_dist} ->
            xdelta = beacon_dist - abs(sy - y)

            if xdelta >= 0,
              do: {sx - xdelta, sx + xdelta},
              else: nil
          end)
          |> Enum.filter(& &1)
          |> Enum.sort_by(&elem(&1, 0))

        {a, b} =
          Enum.reduce_while(rest, start, fn {a, b}, {c, d} ->
            cond do
              d + 1 >= a -> {:cont, {c, max(b, d)}}
              true -> {:halt, {c, d}}
            end
          end)

        cond do
          a <= 0 && b >= grid_limit -> nil
          a > 0 -> {0, y}
          b < grid_limit -> {b + 1, y}
        end
      end)
      |> Stream.filter(& &1)
      |> Enum.take(1)
      |> List.first()

    x * 4_000_000 + y
  end
end
