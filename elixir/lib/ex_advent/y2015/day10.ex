defmodule ExAdvent.Y2015.Day10 do
  def solve_part1 do
    1..40
    |> Enum.reduce(input(), fn _, str -> look_and_say(str) end)
    |> Enum.count()
    |> IO.puts()
  end

  def solve_part2 do
    1..50
    |> Enum.reduce(input(), fn _, str -> look_and_say(str) end)
    |> Enum.count()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day10")
    |> String.trim()
    |> String.to_charlist()
  end

  def look_and_say(input) do
    input
    |> build_chunks()
    |> say_chunks()
  end

  def build_chunks(input) do
    input
    |> Enum.chunk_by(& &1)
  end

  def say_chunks(chunks) do
    chunks
    |> Enum.flat_map(&say_chunk/1)
  end

  def say_chunk(chunk) do
    Integer.to_charlist(Enum.count(chunk)) ++ [List.first(chunk)]
  end
end
