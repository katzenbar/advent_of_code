defmodule ExAdvent.Y2015.Day11 do
  def solve_part1 do
    input()
    |> increment_string()
    |> next_password()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> increment_string()
    |> next_password()
    |> increment_string()
    |> next_password()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day11")
    |> String.trim()
  end

  def next_password(str) do
    Stream.iterate(str, &increment_string/1)
    |> Stream.filter(&meets_requirements?/1)
    |> Stream.take(1)
    |> Enum.to_list()
    |> List.first()
  end

  def increment_string("zzzzzzzz") do
    "aaaaaaaa"
  end

  def increment_string(str) do
    Integer.to_string(String.to_integer(str, 36) + 1, 36)
    |> String.downcase()
    |> String.replace("0", "a")
  end

  def meets_requirements?(str) do
    has_no_ambiguous_characters?(str) && contains_two_pairs?(str) && has_straight?(str)
  end

  def has_straight?(str) do
    straight_sequences =
      ?a..?x
      |> Enum.map(fn x -> Enum.map(0..2, fn y -> x + y end) end)
      |> Enum.map(&List.to_string/1)

    String.contains?(str, straight_sequences)
  end

  def has_no_ambiguous_characters?(str) do
    !String.contains?(str, ["i", "o", "l"])
  end

  def contains_two_pairs?(str) do
    Regex.match?(~r/.*(.)\1.*(.)\2.*/, str)
  end
end
