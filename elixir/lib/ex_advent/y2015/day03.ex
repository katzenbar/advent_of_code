defmodule ExAdvent.Y2015.Day03 do
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

  def input do
    File.read!("inputs/y2015/day03")
    |> String.trim()
    |> String.to_charlist()
  end

  def part1(input) do
    input
    |> Enum.reduce({0, 0, MapSet.new(["0,0"])}, &visit_house/2)
    |> elem(2)
    |> MapSet.size()
  end

  def part2(input) do
    input
    |> Enum.with_index()
    |> Enum.group_by(fn {_dir, index} -> rem(index, 2) end, fn {dir, _index} -> dir end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(fn directions ->
      Enum.reduce(directions, {0, 0, MapSet.new(["0,0"])}, &visit_house/2)
    end)
    |> Enum.map(&elem(&1, 2))
    |> Enum.reduce(&MapSet.union/2)
    |> MapSet.size()
  end

  def visit_house(direction, {curr_x, curr_y, visited_locations}) do
    {x, y} = next_location(direction, curr_x, curr_y)
    {x, y, MapSet.put(visited_locations, Enum.join([x, y], ","))}
  end

  def next_location(?>, x, y) do
    {x + 1, y}
  end

  def next_location(?<, x, y) do
    {x - 1, y}
  end

  def next_location(?^, x, y) do
    {x, y + 1}
  end

  def next_location(?v, x, y) do
    {x, y - 1}
  end
end
