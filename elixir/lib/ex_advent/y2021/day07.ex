defmodule ExAdvent.Y2021.Day07 do
  def solve_part1 do
    input()
    |> parse_input()
    |> min_fuel_required_to_align(&fuel_required_to_align_on_position_constant_rate/2)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> min_fuel_required_to_align(&fuel_required_to_align_on_position_increasing_rate/2)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day07")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def min_fuel_required_to_align(crab_positions, fuel_required_fn) do
    {min, max} = Enum.min_max(crab_positions)

    min..max
    |> Enum.map(&fuel_required_fn.(&1, crab_positions))
    |> Enum.min()
  end

  def fuel_required_to_align_on_position_constant_rate(alignment_position, crab_positions) do
    crab_positions
    |> Enum.map(&abs(&1 - alignment_position))
    |> Enum.sum()
  end

  def fuel_required_to_align_on_position_increasing_rate(alignment_position, crab_positions) do
    crab_positions
    |> Enum.map(fn crab_pos ->
      if crab_pos == alignment_position, do: 0, else: Enum.sum(1..abs(crab_pos - alignment_position))
    end)
    |> Enum.sum()
  end
end
