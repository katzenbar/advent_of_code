defmodule ExAdvent.Y2022.Day04 do
  def solve_part1 do
    input()
    |> parse_input()
    |> Enum.count(&do_assignments_fully_overlap/1)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> Enum.count(&do_assignments_partially_overlap/1)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day04")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_input_line/1)
  end

  def parse_input_line(line) do
    [a, b, c, d] =
      line
      |> String.split(~r/[-,]/)
      |> Enum.map(&String.to_integer/1)

    {{a, b}, {c, d}}
  end

  def do_assignments_fully_overlap({{a, b}, {c, d}}) do
    (a >= c && b <= d) || (c >= a && d <= b)
  end

  def do_assignments_partially_overlap({{a, b}, {c, d}}) do
    !(b < c) && !(a > d)
  end
end
