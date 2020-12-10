defmodule ExAdvent.Y2020.Day10 do
  def solve_part1 do
    input()
    |> parse_input()
    |> add_outlet_and_device()
    |> find_difference_counts()
    |> combine_differences_pt1()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> add_outlet_and_device()
    |> find_possible_combinations()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day10")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def add_outlet_and_device(adapters) do
    [0 | [Enum.max(adapters) + 3 | adapters]]
  end

  def find_difference_counts(joltages) do
    joltages
    |> Enum.sort()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce({0, 0, 0}, fn [a, b], {one, two, three} ->
      case b - a do
        1 -> {one + 1, two, three}
        2 -> {one, two + 1, three}
        3 -> {one, two, three + 1}
      end
    end)
  end

  def combine_differences_pt1({one, _, three}) do
    one * three
  end

  def find_possible_combinations(joltages) do
    joltages
    |> Enum.sort()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)
    # Find all the running groups of 1 gaps with at least two members, count their length
    |> Enum.chunk_by(&(&1 == 3))
    |> Enum.filter(fn [x | rest] -> x == 1 && rest != [] end)
    |> Enum.map(&Enum.count/1)
    # Find the count of combinations we can remove, we can select one or two items to remove
    # This doesn't work with gaps larger than 5, but we only have up to 4 in our input
    |> Enum.map(fn ones_count ->
      case ones_count do
        # do nothing, or remove one number
        2 ->
          2

        # do nothing, remove one number, remove two numbers
        ones_count ->
          1 + number_of_combinations(ones_count - 1, 1) +
            number_of_combinations(ones_count - 1, 2)
      end
    end)
    # Take all of the ways we can manipulate each chunk, multiply them together to get the possible combinations
    |> Enum.reduce(&*/2)
  end

  def number_of_combinations(item_count, chosen_count) do
    div(factorial(item_count), factorial(chosen_count) * factorial(item_count - chosen_count))
  end

  # From https://inquisitivedeveloper.com/lwm-elixir-35/
  def factorial(n), do: factorial(n, 1)
  defp factorial(0, current_factorial), do: current_factorial
  defp factorial(n, current_factorial) when n > 0, do: factorial(n - 1, current_factorial * n)
end
