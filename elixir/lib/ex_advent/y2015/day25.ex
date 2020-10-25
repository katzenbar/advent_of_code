defmodule ExAdvent.Y2015.Day25 do
  def solve_part1 do
    input()
    |> parse_input()
    |> coordinates_to_ordinal()
    |> get_nth_code()
    |> IO.puts()
  end

  def solve_part2 do
    "no puzzle"
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day25")
  end

  def parse_input(input) do
    %{"r" => r, "c" => c} = Regex.named_captures(~r/row (?<r>\d+), column (?<c>\d+)/, input)
    {String.to_integer(r), String.to_integer(c)}
  end

  def coordinates_to_ordinal({1, column}) do
    Enum.sum(1..column)
  end

  def coordinates_to_ordinal({row, column}) do
    coordinates_to_ordinal({1, column}) + Enum.sum(column..(column + row - 2))
  end

  def get_nth_code(1) do
    20_151_125
  end

  def get_nth_code(n) do
    rem(get_nth_code(n - 1) * 252_533, 33_554_393)
  end
end
