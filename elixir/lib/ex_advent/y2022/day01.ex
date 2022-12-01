defmodule ExAdvent.Y2022.Day01 do
  def solve_part1 do
    input()
    |> parse_input()
    |> get_calorie_counts()
    |> Enum.max()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> get_top_three_total()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day01")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&parse_input_line/1)
  end

  def parse_input_line(line) do
    line
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def get_calorie_counts(snacks) do
    snacks
    |> Enum.map(&Enum.sum/1)
  end

  def get_top_three_total(snacks) do
    snacks
    |> get_calorie_counts()
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.sum()
  end
end
