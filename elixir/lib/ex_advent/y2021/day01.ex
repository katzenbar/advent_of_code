defmodule ExAdvent.Y2021.Day01 do
  def solve_part1 do
    input()
    |> parse_input()
    |> count_depth_increases()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> count_window_depth_increases()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day01")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def count_depth_increases(measurements) do
    measurements
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> a < b end)
  end

  def count_window_depth_increases(measurements) do
    measurements
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> a < b end)
  end
end
