defmodule ExAdvent.Y2021.Day17 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_max_vertical_velocity()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> count_possible_initial_velocities()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day17")
  end

  def parse_input(input) do
    input = String.trim(input)

    result =
      Regex.named_captures(
        ~r/^target area: x=(?<min_x>-?\d+)..(?<max_x>-?\d+), y=(?<min_y>-?\d+)..(?<max_y>-?\d+)$/,
        input
      )

    %{
      min_x: String.to_integer(result["min_x"]),
      max_x: String.to_integer(result["max_x"]),
      min_y: String.to_integer(result["min_y"]),
      max_y: String.to_integer(result["max_y"])
    }
  end

  def find_max_vertical_velocity(target) do
    max_y = -1 * target[:min_y] - 1

    Stream.map(target[:min_y]..max_y, fn x_vel -> simulate_launch({x_vel, max_y}, target) end)
    |> Stream.filter(fn %{position: {x, y}} -> point_in_target({x, y}, target) end)
    |> Enum.to_list()
    |> Enum.flat_map(fn %{previous_positions: previous_positions} -> previous_positions end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.max()
  end

  def count_possible_initial_velocities(target) do
    max_y = -1 * target[:min_y] - 1

    Stream.map(target[:min_y]..max_y, fn y_vel ->
      Stream.map(1..target[:max_x], fn x_vel -> simulate_launch({x_vel, y_vel}, target) end)
      |> Stream.filter(fn %{position: {x, y}} -> point_in_target({x, y}, target) end)
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  def point_beyond_target({x, y}, target) do
    x > target[:max_x] || y < target[:min_y]
  end

  def point_could_hit_target({x, y}, target) do
    x <= target[:max_x] && y >= target[:min_y] && !point_in_target({x, y}, target)
  end

  def point_in_target({x, y}, target) do
    target[:min_x] <= x && x <= target[:max_x] && target[:min_y] <= y && y <= target[:max_y]
  end

  def simulate_launch(velocity, target) do
    state = %{
      position: {0, 0},
      previous_positions: [],
      velocity: velocity
    }

    Stream.iterate(state, fn %{position: {x_pos, y_pos}, previous_positions: prev_pos, velocity: {x_vel, y_vel}} ->
      prev_pos = [{x_pos, y_pos} | prev_pos]
      x_pos = x_pos + x_vel
      y_pos = y_pos + y_vel
      velocity = update_velocity({x_vel, y_vel})

      %{position: {x_pos, y_pos}, previous_positions: prev_pos, velocity: velocity}
    end)
    |> Stream.drop_while(fn %{position: position} -> point_could_hit_target(position, target) end)
    |> Enum.take(1)
    |> List.first()
  end

  defp update_velocity({x_vel, y_vel}) do
    x_vel = if x_vel > 1, do: x_vel - 1, else: 0
    y_vel = y_vel - 1

    {x_vel, y_vel}
  end
end
