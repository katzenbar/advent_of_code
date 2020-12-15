defmodule ExAdvent.Y2020.Day15 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_nth_number(2020)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_nth_number(30_000_000)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day15")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def find_nth_number(starting_numbers, target) do
    start_state = {
      Enum.count(starting_numbers),
      List.last(starting_numbers),
      starting_numbers
      |> Enum.slice(0..-2)
      |> Enum.with_index(1)
      |> Enum.reduce(%{}, fn {v, i}, map -> Map.put(map, v, i) end)
    }

    start_state
    |> Stream.iterate(&generate_next_number/1)
    |> Stream.filter(fn {turn, _, _} -> turn == target end)
    |> Enum.at(0)
    |> elem(1)
  end

  def generate_next_number({turn, last_number, last_seen_map}) do
    next_number =
      case Map.get(last_seen_map, last_number) do
        nil -> 0
        last_seen_turn -> turn - last_seen_turn
      end

    {turn + 1, next_number, Map.put(last_seen_map, last_number, turn)}
  end
end
