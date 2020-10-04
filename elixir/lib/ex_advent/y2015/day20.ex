defmodule ExAdvent.Y2015.Day20 do
  def solve_part1 do
    input()
    |> lowest_house_with_num_presents_pt1()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> lowest_house_with_num_presents_pt2()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day20")
    |> String.trim()
    |> String.to_integer()
  end

  def lowest_house_with_num_presents_pt1(num) do
    Stream.iterate(1, &(&1 + 1))
    |> Stream.map(fn n -> {n, presents_delivered_to_house_pt1(n)} end)
    |> Stream.filter(fn {_n, num_presents} -> num_presents >= num end)
    |> Stream.take(1)
    |> Enum.at(0)
    |> elem(0)
  end

  def presents_delivered_to_house_pt1(num) do
    Enum.sum(divisors(num)) * 10
  end

  def divisors(num) do
    1..(:math.sqrt(num) |> trunc())
    |> Enum.filter(fn x -> rem(num, x) == 0 end)
    |> Enum.flat_map(fn x ->
      y = div(num, x)

      cond do
        x == y -> [x]
        true -> [x, y]
      end
    end)
    |> Enum.sort()
  end

  def lowest_house_with_num_presents_pt2(num) do
    Stream.iterate(1, &(&1 + 1))
    |> Stream.map(fn n -> {n, presents_delivered_to_house_pt2(n)} end)
    |> Stream.filter(fn {_n, num_presents} -> num_presents >= num end)
    |> Stream.take(1)
    |> Enum.at(0)
    |> elem(0)
  end

  def presents_delivered_to_house_pt2(n) do
    (n
    |> divisors()
    |> Enum.filter(fn d -> div(n, d) <= 50 end)
    |> Enum.sum()) * 11
  end
end
