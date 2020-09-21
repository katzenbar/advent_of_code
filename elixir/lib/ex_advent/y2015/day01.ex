defmodule ExAdvent.Y2015.Day01 do
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

  @spec input :: binary
  def input do
    File.read!("inputs/y2015/day01")
    |> String.trim()
  end

  @spec part1(binary) :: number
  def part1(input) do
    String.to_charlist(input)
    |> Enum.reduce(0, fn ch, acc -> change_floors(ch, acc) end)
  end

  @spec change_floors(40 | 41, number) :: number
  def change_floors(?), floor) do
    floor - 1
  end

  def change_floors(?(, floor) do
    floor + 1
  end

  @spec part2(binary) :: number
  def part2(input) do
    String.to_charlist(input)
    |> Stream.scan(0, fn ch, acc -> change_floors(ch, acc) end)
    |> Stream.with_index(1)
    |> Stream.drop_while(fn {floor, _idx} -> floor >= 0 end)
    |> Stream.take(1)
    |> Enum.at(0)
    |> elem(1)
  end
end
