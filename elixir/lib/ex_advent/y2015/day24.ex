defmodule ExAdvent.Y2015.Day24 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_best_allocation(3)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_best_allocation(4)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day24")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def find_best_allocation(weights, groups) do
    target_weight = div(Enum.sum(weights), groups)

    1..Enum.count(weights)
    |> Stream.flat_map(fn count ->
      weights
      |> combinations(count)
      |> Stream.filter(fn packages -> Enum.sum(packages) == target_weight end)
      |> Enum.sort_by(&{packages_in_compartment(&1), quantum_entanglement(&1)})
    end)
    |> Enum.at(0)
    |> quantum_entanglement()
  end

  def packages_in_compartment(packages) do
    Enum.count(packages)
  end

  def quantum_entanglement(packages) do
    Enum.reduce(packages, &*/2)
  end

  @spec combinations(any, any) :: [any]
  def combinations(_, 0), do: [[]]

  def combinations([], _), do: []

  def combinations([h | t], k) do
    (for(l <- combinations(t, k - 1), do: [h | l]) ++ combinations(t, k))
    |> Enum.uniq()
  end

  def combinations(enum, k), do: combinations(Enum.to_list(enum), k)
end
