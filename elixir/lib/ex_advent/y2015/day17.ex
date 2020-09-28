defmodule ExAdvent.Y2015.Day17 do
  def solve_part1 do
    input()
    |> containers_to_store_exact_amount(150)
    |> Enum.count()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> part2(150)
    |> Enum.count()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day17")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def part2(containers, amount) do
    containers_with_amount = containers_to_store_exact_amount(containers, amount)
    min_num_containers = containers_with_amount |> Enum.map(&Enum.count/1) |> Enum.min()

    containers_with_amount |> Enum.filter(fn x -> Enum.count(x) == min_num_containers end)
  end

  def containers_to_store_exact_amount(containers, amount) do
    containers
    |> combine_containers()
    |> Enum.filter(fn combination -> Enum.sum(combination) == amount end)
  end

  def combine_containers(containers) do
    1..floor(:math.pow(2, Enum.count(containers)) - 1)
    |> Stream.map(&Integer.to_string(&1, 2))
    |> Stream.map(&String.pad_leading(&1, Enum.count(containers), "0"))
    |> Stream.map(&String.to_charlist/1)
    |> Stream.map(fn flags -> Enum.zip(containers, flags) end)
    |> Stream.map(fn x -> Enum.filter(x, fn {_container, flag} -> flag == ?1 end) end)
    |> Stream.map(fn x -> Enum.map(x, &elem(&1, 0)) end)
    |> Enum.to_list()
  end
end
