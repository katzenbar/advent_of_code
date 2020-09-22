defmodule ExAdvent.Y2015.Day05 do
  def solve_part1 do
    input()
    |> Enum.count(&part1_nice_string?/1)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> Enum.count(&part2_nice_string?/1)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day05")
    |> String.trim()
    |> String.split()
  end

  def part1_nice_string?(str) do
    !String.contains?(str, ["ab", "cd", "pq", "xy"]) && String.match?(str, ~r/(.)(?=\1)/) &&
      String.match?(str, ~r/.*([aeiou].*){3}/)
  end

  def part2_nice_string?(str) do
    contains_repeating_pair?(str) && contains_repeat_sandwich?(str)
  end

  def contains_repeating_pair?(str) do
    String.match?(str, ~r/.*(..).*(?=\1).*/)
  end

  def contains_repeat_sandwich?(str) do
    String.match?(str, ~r/.*(.).(?=\1).*/)
  end
end
