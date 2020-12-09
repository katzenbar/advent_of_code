defmodule ExAdvent.Y2020.Day09 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_first_invalid_number(25)
    |> IO.puts()
  end

  def solve_part2 do
    numbers =
      input()
      |> parse_input()

    find_contiguous_elements_with_sum(numbers, find_first_invalid_number(numbers, 25))
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day09")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def find_first_invalid_number(numbers, preamble_length) do
    preamble_length..(Enum.count(numbers) - 1)
    |> Stream.filter(fn index ->
      nil ==
        find_two_elements_with_sum(
          Enum.slice(numbers, (index - preamble_length)..(index - 1)),
          Enum.at(numbers, index)
        )
    end)
    |> Stream.map(fn index ->
      Enum.at(numbers, index)
    end)
    |> Enum.at(0)
  end

  def find_two_elements_with_sum(elements, target_sum) do
    elements
    |> Stream.flat_map(fn el1 ->
      Stream.map(elements, fn el2 -> [el1, el2] end)
    end)
    |> Stream.filter(fn [el1, el2] -> el1 + el2 == target_sum end)
    |> Enum.at(0)
  end

  def find_contiguous_elements_with_sum(elements, target_sum) do
    0..(Enum.count(elements) - 1)
    |> Stream.map(fn index ->
      elements
      |> Enum.slice(index..-1)
      |> Enum.reduce_while({0, []}, fn val, {sum, elements} ->
        next_sum = sum + val

        if next_sum < target_sum,
          do: {:cont, {next_sum, [val | elements]}},
          else: {:halt, {next_sum, [val | elements]}}
      end)
    end)
    |> Stream.filter(fn {sum, _} ->
      sum == target_sum
    end)
    |> Stream.map(fn {_, reversed_el} ->
      {min, max} = Enum.min_max(reversed_el)
      min + max
    end)
    |> Enum.at(0)
  end
end
