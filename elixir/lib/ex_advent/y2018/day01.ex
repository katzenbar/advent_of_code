defmodule ExAdvent.Y2018.Day01 do
  def solve_part1 do
    input()
    |> parse_input()
    |> get_resulting_frequency()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_first_duplicate()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2018/day01")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def get_resulting_frequency(frequency_changes) do
    frequency_changes
    |> Enum.sum()
  end

  def find_first_duplicate(frequency_changes) do
    frequency_changes
    |> Stream.cycle()
    |> Stream.transform({0, MapSet.new()}, fn
      change, {current_freq, visited_freqs} ->
        case(MapSet.member?(visited_freqs, current_freq)) do
          true ->
            {:halt, visited_freqs}

          _ ->
            visited_freqs = MapSet.put(visited_freqs, current_freq)
            next_freq = current_freq + change
            {[next_freq], {next_freq, visited_freqs}}
        end
    end)
    |> Enum.to_list()
    |> List.last()
  end
end
