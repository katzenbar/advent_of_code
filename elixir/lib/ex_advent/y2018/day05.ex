defmodule ExAdvent.Y2018.Day05 do
  def solve_part1 do
    input()
    |> parse_input()
    |> simulate_polymer_reaction()
    |> String.length()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_most_improved_polymer()
    |> String.length()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2018/day05")
  end

  def parse_input(input) do
    input
    |> String.trim()
  end

  def simulate_polymer_reaction(polymer) do
    reaction_patterns = Enum.flat_map(?A..?Z, fn ch -> [to_string([ch + 32, ch]), to_string([ch, ch + 32])] end)

    polymer
    |> Stream.unfold(fn polymer ->
      next_polymer = String.replace(polymer, reaction_patterns, "", global: true)
      if polymer == next_polymer, do: nil, else: {next_polymer, next_polymer}
    end)
    |> Enum.to_list()
    |> List.last()
  end

  def find_most_improved_polymer(polymer) do
    ?A..?Z
    |> Enum.map(fn ch -> [to_string([ch]), to_string([ch + 32])] end)
    |> Enum.map(fn removals -> String.replace(polymer, removals, "", global: true) end)
    |> Enum.map(&simulate_polymer_reaction/1)
    |> Enum.min_by(&String.length/1)
  end
end
