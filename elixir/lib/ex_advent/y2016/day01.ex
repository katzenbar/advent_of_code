defmodule ExAdvent.Y2016.Day01 do
  def solve_part1 do
    input()
    |> parse_input()
    |> execute_instructions_pt1()
    |> distance_to_point()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> execute_instructions_pt2()
    |> distance_to_point()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2016/day01")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(", ")
  end

  def execute_instructions_pt1(instructions) do
    Enum.reduce(instructions, {0, 0, 0}, &execute_instruction/2)
  end

  def execute_instruction(<<direction::bytes-size(1)>> <> distance, state) do
    state
    |> turn(direction)
    |> walk(String.to_integer(distance))
  end

  def turn({dir, x, y}, "L") do
    {rem(dir - 90 + 360, 360), x, y}
  end

  def turn({dir, x, y}, "R") do
    {rem(dir + 90, 360), x, y}
  end

  def walk({0, x, y}, distance) do
    {0, x, y + distance}
  end

  def walk({90, x, y}, distance) do
    {90, x + distance, y}
  end

  def walk({180, x, y}, distance) do
    {180, x, y - distance}
  end

  def walk({270, x, y}, distance) do
    {270, x - distance, y}
  end

  def distance_to_point({_, x, y}) do
    abs(x) + abs(y)
  end

  def distance_to_point({x, y}) do
    abs(x) + abs(y)
  end

  def execute_instructions_pt2(instructions) do
    instructions
    |> Enum.reduce([{0, 0, 0}], &execute_instruction_pt2/2)
    |> Enum.map(fn {_d, x, y} -> {x, y} end)
    |> Enum.reduce_while(MapSet.new(), fn coord, visited ->
      case MapSet.member?(visited, coord) do
        true -> {:halt, coord}
        false -> {:cont, MapSet.put(visited, coord)}
      end
    end)
  end

  def execute_instruction_pt2(<<direction::bytes-size(1)>> <> distance, visited) do
    next =
      List.last(visited)
      |> turn(direction)
      |> walk_pt2(String.to_integer(distance))

    Enum.concat(visited, next)
  end

  def walk_pt2({0, x, y}, distance) do
    Enum.map((y + 1)..(y + distance), fn yi -> {0, x, yi} end)
  end

  def walk_pt2({90, x, y}, distance) do
    Enum.map((x + 1)..(x + distance), fn xi -> {90, xi, y} end)
  end

  def walk_pt2({180, x, y}, distance) do
    Enum.map((y - 1)..(y - distance), fn yi -> {180, x, yi} end)
  end

  def walk_pt2({270, x, y}, distance) do
    Enum.map((x - 1)..(x - distance), fn xi -> {270, xi, y} end)
  end
end
