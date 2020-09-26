defmodule ExAdvent.Y2015.Day12 do
  def solve_part1 do
    input()
    |> sum_json_numbers()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> sum_json_numbers_pt2()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day12")
    |> String.trim()
  end

  def sum_json_numbers(input) do
    input
    |> Jason.decode!()
    |> sum_numbers()
  end

  def sum_numbers(input) when is_integer(input) do
    input
  end

  def sum_numbers(input) when is_list(input) do
    input
    |> Enum.map(&sum_numbers/1)
    |> Enum.sum()
  end

  def sum_numbers(input) when is_map(input) do
    input
    |> Map.values()
    |> Enum.map(&sum_numbers/1)
    |> Enum.sum()
  end

  def sum_numbers(input) when is_binary(input) do
    0
  end

  def sum_json_numbers_pt2(input) do
    input
    |> Jason.decode!()
    |> sum_numbers_pt2()
  end

  def sum_numbers_pt2(input) when is_integer(input) do
    input
  end

  def sum_numbers_pt2(input) when is_list(input) do
    input
    |> Enum.map(&sum_numbers_pt2/1)
    |> Enum.sum()
  end

  def sum_numbers_pt2(input) when is_map(input) do
    cond do
      Enum.member?(Map.values(input), "red") ->
        0

      true ->
        input
        |> Map.values()
        |> Enum.map(&sum_numbers_pt2/1)
        |> Enum.sum()
    end
  end

  def sum_numbers_pt2(input) when is_binary(input) do
    0
  end
end
