defmodule ExAdvent.Y2016.Day03 do
  def solve_part1 do
    input()
    |> parse_input()
    |> count_triangles_pt1()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> count_triangles_pt2()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2016/day03")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn x -> x |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1) end)
  end

  def is_triangle?(sides) do
    [a, b, c] = Enum.sort(sides, :desc)
    a < b + c
  end

  def count_triangles_pt1(input) do
    input
    |> Enum.filter(&is_triangle?/1)
    |> Enum.count()
  end

  def count_triangles_pt2(input) do
    input
    |> Enum.chunk_every(3)
    |> Enum.flat_map(fn [one, two, three] ->
      [one_a, one_b, one_c] = one
      [two_a, two_b, two_c] = two
      [three_a, three_b, three_c] = three

      [
        [one_a, two_a, three_a],
        [one_b, two_b, three_b],
        [one_c, two_c, three_c]
      ]
    end)
    |> Enum.filter(&is_triangle?/1)
    |> Enum.count()
  end
end
