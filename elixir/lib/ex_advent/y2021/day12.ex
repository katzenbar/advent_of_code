defmodule ExAdvent.Y2021.Day12 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_all_paths(1)
    |> length()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_all_paths(2)
    |> length()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day12")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(%{}, fn [a, b], map ->
      map
      |> Map.update(a, [b], &[b | &1])
      |> Map.update(b, [a], &[a | &1])
    end)
  end

  def find_all_paths(paths_map, max_times_visit_small_cave, current_cave \\ "start", visited_caves \\ []) do
    visited_caves = [current_cave | visited_caves]

    has_visited_small_cave_twice =
      visited_caves
      |> Enum.reduce(%{}, fn cave, count_map ->
        if is_large_cave?(cave), do: count_map, else: Map.update(count_map, cave, 1, &(&1 + 1))
      end)
      |> Map.values()
      |> Enum.any?(&(&1 > 1))

    next_options =
      paths_map
      |> Map.get(current_cave, [])
      |> Enum.filter(fn cave ->
        num_visits = Enum.count(visited_caves, &(cave == &1))

        cave != "start" &&
          (is_large_cave?(cave) || num_visits < 1 ||
             (!has_visited_small_cave_twice && num_visits < max_times_visit_small_cave))
      end)

    cond do
      current_cave == "end" ->
        [Enum.reverse(visited_caves)]

      next_options == [] ->
        []

      true ->
        Enum.flat_map(next_options, &find_all_paths(paths_map, max_times_visit_small_cave, &1, visited_caves))
    end
  end

  defp is_large_cave?(str), do: String.upcase(str) == str
end
