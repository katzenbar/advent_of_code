defmodule ExAdvent.Y2022.Day12 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_fewest_steps_start_to_end()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_fewest_steps_end_trail()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day12")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, &parse_line/2)
  end

  def parse_line({line, row_idx}, height_map) do
    line
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(height_map, fn {ch_str, col_idx}, height_map ->
      case ch_str do
        "S" ->
          Map.put(height_map, {col_idx, row_idx}, 0)
          |> Map.put(:start, {col_idx, row_idx})

        "E" ->
          Map.put(height_map, {col_idx, row_idx}, 25)
          |> Map.put(:end, {col_idx, row_idx})

        _ ->
          ch = List.first(to_charlist(ch_str)) - ?a
          Map.put(height_map, {col_idx, row_idx}, ch)
      end
    end)
  end

  def find_fewest_steps_start_to_end(height_map) do
    start = Map.get(height_map, :start)
    goals = MapSet.new([Map.get(height_map, :end)])
    open = [{start, estimate_travel_cost(start, goals)}]
    closed = %{start => 0}

    find_path_astar(height_map, goals, open, closed, fn from_height, to_height -> to_height <= from_height + 1 end)
  end

  def find_fewest_steps_end_trail(height_map) do
    start = Map.get(height_map, :end)

    goals =
      height_map
      |> Map.filter(fn {_, height} -> height == 0 end)
      |> Map.keys()
      |> MapSet.new()

    open = [{start, estimate_travel_cost(start, goals)}]
    closed = %{start => 0}

    find_path_astar(height_map, goals, open, closed, fn from_height, to_height -> from_height <= to_height + 1 end)
  end

  defp find_path_astar(height_map, goals, open, closed, allow_move_fn) do
    [{current, _} | open_rest] = Enum.sort_by(open, &elem(&1, 1))

    current_cost = Map.get(closed, current)

    cond do
      MapSet.member?(goals, current) ->
        current_cost

      true ->
        {x, y} = current
        current_height = Map.get(height_map, current)

        {open, closed} =
          [{0, -1}, {0, 1}, {-1, 0}, {1, 0}]
          |> Enum.map(fn {dx, dy} ->
            point = {x + dx, y + dy}
            # make this so high we wouldn't climb up the edges of the grid
            height = Map.get(height_map, point, 100)
            {point, height}
          end)
          |> Enum.filter(fn {_, height} -> allow_move_fn.(current_height, height) end)
          |> Enum.reduce({open_rest, closed}, fn {point, _}, {open, closed} ->
            new_cost = current_cost + 1

            cond do
              !Map.has_key?(closed, point) || new_cost < Map.get(closed, point) ->
                closed = Map.put(closed, point, new_cost)
                priority = new_cost + estimate_travel_cost(point, goals)
                open = [{point, priority} | open]
                {open, closed}

              true ->
                {open, closed}
            end
          end)

        find_path_astar(height_map, goals, open, closed, allow_move_fn)
    end
  end

  # Use manhattan distance as our heuristic
  defp estimate_travel_cost({point_x, point_y}, goals) do
    goals
    |> Enum.map(fn {goal_x, goal_y} -> abs(point_x - goal_x) + abs(point_y - goal_y) end)
    |> Enum.min()
  end
end
