defmodule ExAdvent.Y2022.Day06 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_packet_marker(4)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_packet_marker(14)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day06")
  end

  def parse_input(input) do
    input
    |> String.trim()
  end

  def find_packet_marker(str, unique_len) do
    str
    |> to_charlist()
    |> Stream.chunk_every(unique_len, 1)
    |> Stream.with_index(unique_len)
    |> Stream.filter(fn {x, _} -> MapSet.size(MapSet.new(x)) == unique_len end)
    |> Enum.at(0)
    |> elem(1)
  end
end
