defmodule ExAdvent.Y2015.Day02 do
  def solve_part1 do
    File.read!("inputs/y2015/day02")
    |> String.trim()
    |> String.split()
    |> Enum.map(&sqft_paper_required/1)
    |> Enum.sum()
    |> IO.puts()
  end

  def solve_part2 do
    File.read!("inputs/y2015/day02")
    |> String.trim()
    |> String.split()
    |> Enum.map(&length_ribbon_required/1)
    |> Enum.sum()
    |> IO.puts()
  end

  def sqft_paper_required(dimensions) do
    [l, w, h] = box_dimensions(dimensions)

    3 * l * w + 2 * l * h + 2 * w * h
  end

  def length_ribbon_required(dimensions) do
    [l, w, h] = box_dimensions(dimensions)

    2 * l + 2 * w + l * w * h
  end

  def box_dimensions(dimensions) do
    String.split(dimensions, "x")
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(fn x -> elem(x, 0) end)
    |> Enum.sort()
  end
end
