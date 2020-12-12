defmodule ExAdvent.Y2020.Day12 do
  def solve_part1 do
    input()
    |> parse_input()
    |> follow_navigation_instructions()
    |> get_manhattan_distance_for_ship()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> follow_instructions_with_waypoint()
    |> get_manhattan_distance_for_ship()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day12")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    {dir, val} = String.split_at(line, 1)
    {dir, String.to_integer(val)}
  end

  def get_manhattan_distance_for_ship(%{x: x, y: y}) do
    abs(x) + abs(y)
  end

  def follow_navigation_instructions(instructions) do
    Enum.reduce(instructions, %{x: 0, y: 0, heading: 0}, &follow_instruction/2)
  end

  # Action N means to move north by the given value.
  # Action S means to move south by the given value.
  # Action E means to move east by the given value.
  # Action W means to move west by the given value.
  # Action L means to turn left the given number of degrees.
  # Action R means to turn right the given number of degrees.
  # Action F means to move forward by the given value in the direction the ship is currently facing.

  @spec follow_instruction({<<_::8>>, any}, map) :: map
  def follow_instruction({"N", val}, ship), do: Map.update!(ship, :y, fn v -> v + val end)
  def follow_instruction({"S", val}, ship), do: Map.update!(ship, :y, fn v -> v - val end)
  def follow_instruction({"E", val}, ship), do: Map.update!(ship, :x, fn v -> v + val end)
  def follow_instruction({"W", val}, ship), do: Map.update!(ship, :x, fn v -> v - val end)

  def follow_instruction({"F", val}, ship = %{heading: 0}),
    do: Map.update!(ship, :x, fn v -> v + val end)

  def follow_instruction({"F", val}, ship = %{heading: 90}),
    do: Map.update!(ship, :y, fn v -> v + val end)

  def follow_instruction({"F", val}, ship = %{heading: 180}),
    do: Map.update!(ship, :x, fn v -> v - val end)

  def follow_instruction({"F", val}, ship = %{heading: 270}),
    do: Map.update!(ship, :y, fn v -> v - val end)

  def follow_instruction({"L", val}, ship),
    do: Map.update!(ship, :heading, fn v -> rem(v + val, 360) end)

  def follow_instruction({"R", val}, ship),
    do: Map.update!(ship, :heading, fn v -> rem(v - val + 360, 360) end)

  # Action N means to move the waypoint north by the given value.
  # Action S means to move the waypoint south by the given value.
  # Action E means to move the waypoint east by the given value.
  # Action W means to move the waypoint west by the given value.
  # Action L means to rotate the waypoint around the ship left (counter-clockwise) the given number of degrees.
  # Action R means to rotate the waypoint around the ship right (clockwise) the given number of degrees.
  # Action F means to move forward to the waypoint a number of times equal to the given value.

  def follow_instructions_with_waypoint(instructions) do
    Enum.reduce(
      instructions,
      %{x: 0, y: 0, way_x: 10, way_y: 1},
      &follow_instruction_with_waypoint/2
    )
  end

  def follow_instruction_with_waypoint({"N", val}, coords),
    do: Map.update!(coords, :way_y, &(&1 + val))

  def follow_instruction_with_waypoint({"S", val}, coords),
    do: Map.update!(coords, :way_y, &(&1 - val))

  def follow_instruction_with_waypoint({"E", val}, coords),
    do: Map.update!(coords, :way_x, &(&1 + val))

  def follow_instruction_with_waypoint({"W", val}, coords),
    do: Map.update!(coords, :way_x, &(&1 - val))

  def follow_instruction_with_waypoint({"L", 0}, coords), do: coords

  def follow_instruction_with_waypoint({"L", val}, coords) do
    updated_coords =
      coords
      |> Map.put(:way_x, -1 * Map.get(coords, :way_y))
      |> Map.put(:way_y, Map.get(coords, :way_x))

    follow_instruction_with_waypoint({"L", val - 90}, updated_coords)
  end

  def follow_instruction_with_waypoint({"R", 0}, coords), do: coords

  def follow_instruction_with_waypoint({"R", val}, coords) do
    updated_coords =
      coords
      |> Map.put(:way_x, Map.get(coords, :way_y))
      |> Map.put(:way_y, -1 * Map.get(coords, :way_x))

    follow_instruction_with_waypoint({"R", val - 90}, updated_coords)
  end

  def follow_instruction_with_waypoint({"F", val}, coords) do
    coords
    |> Map.update!(:x, fn x -> x + val * Map.get(coords, :way_x) end)
    |> Map.update!(:y, fn y -> y + val * Map.get(coords, :way_y) end)
  end
end
