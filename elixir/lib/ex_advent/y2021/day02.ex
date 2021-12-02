defmodule ExAdvent.Y2021.Day02 do
  def solve_part1 do
    input()
    |> parse_input()
    |> get_final_up_down_position()
    |> then(fn {pos, depth} -> pos * depth end)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> get_final_aim_position()
    |> then(fn {pos, depth, _} -> pos * depth end)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day02")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(input_line) do
    [dir_str, amount_str] = String.split(input_line, " ")

    amount = String.to_integer(amount_str)
    direction = String.to_atom(dir_str)

    {direction,amount}
  end

  def get_final_up_down_position(directions) do
    directions
    |> chart_up_down_course()
    |> Enum.at(-1)
  end

  def chart_up_down_course(directions) do
    Stream.scan(directions, {0, 0}, fn
      {:forward, amount}, {pos, depth} -> {pos + amount, depth}
      {:down, amount}, {pos, depth} -> {pos, depth + amount}
      {:up, amount}, {pos, depth} -> {pos, depth - amount}
    end)
  end

  def get_final_aim_position(directions) do
    directions
    |> chart_aim_course()
    |> Enum.at(-1)
  end

  def chart_aim_course(directions) do
    Stream.scan(directions, {0, 0, 0}, fn
      {:forward, amount}, {pos, depth, aim} -> {pos + amount, depth + aim * amount, aim}
      {:down, amount}, {pos, depth, aim} -> {pos, depth, aim + amount}
      {:up, amount}, {pos, depth, aim} -> {pos, depth, aim - amount}
    end)
  end
end
