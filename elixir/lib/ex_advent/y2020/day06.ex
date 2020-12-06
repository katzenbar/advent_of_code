defmodule ExAdvent.Y2020.Day06 do
  def solve_part1 do
    input()
    |> parse_input()
    |> Enum.map(&count_anyone_answered/1)
    |> Enum.sum()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> Enum.map(&count_everyone_answered/1)
    |> Enum.sum()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day06")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    line
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
  end

  def count_anyone_answered(group_answers) do
    group_answers
    |> List.flatten()
    |> MapSet.new()
    |> MapSet.size()
  end

  def count_everyone_answered(group_answers) do
    group_answers
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> MapSet.size()
  end
end
