defmodule ExAdvent.Y2015.Day08 do
  def solve_part1 do
    input()
    |> part1()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day08")
    |> String.trim()
    |> String.split("\n")
  end

  def part1(input) do
    unescaped = input |> Enum.map(&String.length/1) |> Enum.sum()

    escaped =
      input
      |> Enum.map(&String.slice(&1, 1..-2))
      |> Enum.map(&replace_escaped_characters/1)
      |> Enum.map(&String.length/1)
      |> Enum.sum()

    unescaped - escaped
  end

  def replace_escaped_characters(str) do
    str
    |> String.replace(~r/(\\x..)|(\\\")|(\\\\)/, "?")
  end
end
