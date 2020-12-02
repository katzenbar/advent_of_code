defmodule ExAdvent.Y2020.Day02 do
  def solve_part1 do
    input()
    |> parse_input()
    |> Enum.count(&valid_old_co_password?/1)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> Enum.count(&valid_toboggan_password?/1)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day02")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    captures = Regex.named_captures(~r/(?<min>\d+)-(?<max>\d+) (?<ch>.): (?<pass>.+)/, line)

    {
      String.to_integer(Map.get(captures, "min")),
      String.to_integer(Map.get(captures, "max")),
      String.to_charlist(Map.get(captures, "ch")) |> List.first(),
      Map.get(captures, "pass")
    }
  end

  def valid_old_co_password?({min, max, ch, password}) do
    count = character_count(password, ch)

    min <= count && count <= max
  end

  def character_count(string, char) do
    string |> String.to_charlist() |> Enum.count(fn x -> x == char end)
  end

  def valid_toboggan_password?({pos1, pos2, ch, password}) do
    chlist = String.to_charlist(password)

    p1check = Enum.at(chlist, pos1 - 1) == ch
    p2check = Enum.at(chlist, pos2 - 1) == ch

    (p1check && !p2check) || (!p1check && p2check)
  end
end
