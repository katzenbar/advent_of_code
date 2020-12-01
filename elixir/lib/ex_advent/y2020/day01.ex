defmodule ExAdvent.Y2020.Day01 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_two_elements_with_sum(2020)
    |> combine_entries()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_three_elements_with_sum(2020)
    |> combine_entries()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day01")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def find_two_elements_with_sum(elements, target_sum) do
    elements
    |> Stream.flat_map(fn el1 ->
      Stream.map(elements, fn el2 -> [el1, el2] end)
    end)
    |> Stream.filter(fn [el1, el2] -> el1 + el2 == target_sum end)
    |> Enum.take(1)
    |> Enum.at(0)
  end

  def find_three_elements_with_sum(elements, target_sum) do
    el_with_index = Enum.with_index(elements)

    el_with_index
    |> Stream.flat_map(fn {el1, idx1} ->
      Stream.flat_map(Enum.slice(el_with_index, idx1..-1), fn {el2, idx2} ->
        Stream.map(Enum.slice(elements, idx2..-1), fn el3 -> [el1, el2, el3] end)
      end)
    end)
    |> Stream.filter(fn entries -> Enum.sum(entries) == target_sum end)
    |> Enum.take(1)
    |> Enum.at(0)
  end

  def combine_entries(entries) do
    Enum.reduce(entries, &*/2)
  end
end
