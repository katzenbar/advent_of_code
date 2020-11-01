defmodule ExAdvent.Y2016.Day06 do
  def solve_part1 do
    input()
    |> parse_input()
    |> most_common_characters_by_column(&most_frequent/1)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> most_common_characters_by_column(&least_frequent/1)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2016/day06")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
  end

  def most_common_characters_by_column(strings, compare_fn) do
    strings
    |> Enum.map(&String.to_charlist/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(compare_fn)
    |> to_string()
  end

  def most_frequent(list) do
    list
    |> Enum.frequencies()
    |> Map.to_list()
    |> Enum.max_by(&elem(&1, 1))
    |> elem(0)
  end

  def least_frequent(list) do
    list
    |> Enum.frequencies()
    |> Map.to_list()
    |> Enum.min_by(&elem(&1, 1))
    |> elem(0)
  end
end
