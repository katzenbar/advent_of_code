defmodule ExAdvent.Y2015.Day04 do
  def solve_part1 do
    input()
    |> find_hash_starting_with("00000")
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> find_hash_starting_with("000000")
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day04")
    |> String.trim()
  end

  def find_hash_starting_with(input, prefix) do
    Stream.iterate(1, &(&1 + 1))
    |> Stream.map(fn num ->
      {num, :crypto.hash(:md5, input <> Integer.to_string(num)) |> Base.encode16()}
    end)
    |> Stream.filter(fn {_num, hash} -> String.starts_with?(hash, prefix) end)
    |> Enum.at(0)
    |> elem(0)
  end
end
