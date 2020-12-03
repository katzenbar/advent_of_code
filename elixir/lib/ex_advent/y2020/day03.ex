defmodule ExAdvent.Y2020.Day03 do
  def solve_part1 do
    input()
    |> parse_input()
    |> trees_encountered_with_slope(1, 3)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> trees_encountered_with_slopes([{1, 1}, {1, 3}, {1, 5}, {1, 7}, {2, 1}])
    |> Enum.reduce(&*/2)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day03")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&to_charlist/1)
  end

  def trees_encountered_with_slope(map, down, right) do
    traverse_with_slope(map, down, right) |> Enum.count(fn ch -> ch == ?# end)
  end

  def traverse_with_slope(map, down, right) do
    map
    |> Enum.take_every(down)
    |> Enum.with_index()
    |> Enum.map(fn {row, idx} ->
      Enum.at(row, Integer.mod(idx * right, Enum.count(row)))
    end)
  end

  def trees_encountered_with_slopes(map, slopes) do
    slopes
    |> Enum.map(fn {down, right} ->
      trees_encountered_with_slope(map, down, right)
    end)
  end
end
