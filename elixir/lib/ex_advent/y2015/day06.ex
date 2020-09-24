defmodule ExAdvent.Y2015.Day06 do
  def solve_part1 do
    solve(&next_value_pt1/2)
  end

  def solve_part2 do
    solve(&next_value_pt2/2)
  end

  def solve(nex_value_fn) do
    input()
    |> Enum.reduce(%{}, fn inst, grid -> execute_instruction(inst, grid, nex_value_fn) end)
    |> Map.values()
    |> Enum.sum()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day06")
    |> String.trim()
    |> String.split("\n")
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

  @spec execute_instruction(binary, map(), function()) :: map()
  def execute_instruction(instruction, grid, next_value_fn) do
    {action, start_x, start_y, end_x, end_y} = parse_instruction(instruction)

    Enum.flat_map(start_x..end_x, fn x -> Enum.map(start_y..end_y, fn y -> {x, y} end) end)
    |> Enum.reduce(
      grid,
      fn {x, y}, grid ->
        {_, next_grid} = Map.get_and_update(grid, "#{x},#{y}", &next_value_fn.(action, &1))
        next_grid
      end
    )
  end

  def next_value_pt1(:on, current_value) do
    {current_value, 1}
  end

  def next_value_pt1(:off, current_value) do
    {current_value, 0}
  end

  def next_value_pt1(:toggle, current_value) do
    case current_value do
      1 -> {current_value, 0}
      _ -> {current_value, 1}
    end
  end

  def next_value_pt2(:on, current_value) do
    case current_value do
      nil -> {nil, 1}
      _ -> {current_value, current_value + 1}
    end
  end

  def next_value_pt2(:off, current_value) do
    case current_value do
      nil -> {nil, 0}
      0 -> {0, 0}
      _ -> {current_value, current_value - 1}
    end
  end

  def next_value_pt2(:toggle, current_value) do
    case current_value do
      nil -> {nil, 2}
      _ -> {current_value, current_value + 2}
    end
  end
end
