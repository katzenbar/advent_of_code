defmodule ExAdvent.Y2015.Day06 do
  def solve_part1 do
    input()
    |> Enum.map(&parse_instruction/1)
    |> Enum.reduce(MapSet.new(), &execute_instruction/2)
    |> MapSet.size()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> Enum.reduce(%{}, &execute_instruction_pt2/2)
    |> Map.values()
    |> Enum.sum()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day06")
    |> String.trim()
    |> String.split("\n")
  end

  def execute_instruction({action, start_x, start_y, end_x, end_y}, grid) do
    Enum.flat_map(start_x..end_x, fn x -> Enum.map(start_y..end_y, fn y -> {x, y} end) end)
    |> Enum.reduce(grid, &take_action(action, &1, &2))
  end

  def take_action(:on, {x, y}, grid) do
    MapSet.put(grid, "#{x},#{y}")
  end

  def take_action(:off, {x, y}, grid) do
    MapSet.delete(grid, "#{x},#{y}")
  end

  def take_action(:toggle, {x, y}, grid) do
    key = "#{x},#{y}"

    case MapSet.member?(grid, key) do
      true -> MapSet.delete(grid, key)
      false -> MapSet.put(grid, key)
    end
  end

  def parse_instruction(instruction) do
    result =
      Regex.named_captures(
        ~r/(?<action>.*) (?<start_x>\d+),(?<start_y>\d+) through (?<end_x>\d+),(?<end_y>\d+)/,
        instruction
      )

    {
      parse_action(result["action"]),
      String.to_integer(result["start_x"]),
      String.to_integer(result["start_y"]),
      String.to_integer(result["end_x"]),
      String.to_integer(result["end_y"])
    }
  end

  def parse_action("turn on") do
    :on
  end

  def parse_action("turn off") do
    :off
  end

  def parse_action("toggle") do
    :toggle
  end

  def execute_instruction_pt2(instruction, grid) do
    {action, start_x, start_y, end_x, end_y} = parse_instruction(instruction)

    Enum.flat_map(start_x..end_x, fn x -> Enum.map(start_y..end_y, fn y -> {x, y} end) end)
    |> Enum.reduce(
      grid,
      fn {x, y}, grid ->
        {_, next_grid} = Map.get_and_update(grid, "#{x},#{y}", &next_value(action, &1))
        next_grid
      end
    )
  end

  def next_value(:on, current_value) do
    case current_value do
      nil -> {nil, 1}
      _ -> {current_value, current_value + 1}
    end
  end

  def next_value(:off, current_value) do
    case current_value do
      nil -> {nil, 0}
      0 -> {0, 0}
      _ -> {current_value, current_value - 1}
    end
  end

  def next_value(:toggle, current_value) do
    case current_value do
      nil -> {nil, 2}
      _ -> {current_value, current_value + 2}
    end
  end
end
