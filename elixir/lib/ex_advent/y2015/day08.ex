defmodule ExAdvent.Y2015.Day08 do
  def solve_part1 do
    input()
    |> part1()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> part2()
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

  def part2(input) do
    unescaped = input |> Enum.map(&String.length/1) |> Enum.sum()

    encoded =
      input
      |> Enum.map(&encoded_character_count/1)
      |> Enum.sum()

    encoded - unescaped
  end

  def replace_escaped_characters(str) do
    str
    |> String.replace(~r/(\\x..)|(\\\")|(\\\\)/, "?")
  end

  def encoded_character_count(str) do
    2 +
      (str
       |> String.replace(["\"", "\\"], "??")
       |> String.length())
  end
end
