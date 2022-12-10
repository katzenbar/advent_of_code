defmodule ExAdvent.Y2022.Day09 do
  def solve_part1 do
    input()
    |> parse_input()
    |> count_visited_locations(1)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> count_visited_locations(9)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day09")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [direction, amount] = String.split(line, " ")
      amount = String.to_integer(amount)

      {direction, amount}
    end)
  end

  def count_visited_locations(steps, num_links) do
    steps
    |> simulate_steps(num_links)
    |> Stream.map(fn {_, _, tails} -> List.last(tails) end)
    |> Enum.to_list()
    |> MapSet.new()
    |> MapSet.size()
  end

  def simulate_steps(steps, num_links) do
    tails = Stream.repeatedly(fn -> {0, 0} end) |> Enum.take(num_links)

    Stream.iterate({steps, {0, 0}, tails}, &simulate_step/1)
    |> Stream.chunk_every(2, 1)
    |> Stream.take_while(fn [{s1, _, _}, {s2, _, _}] -> length(s1) > 0 || length(s2) > 0 end)
    |> Stream.map(fn [_, x] -> x end)
  end

  def simulate_step({[], head, tails}), do: {[], head, tails}

  def simulate_step({[{direction, count} | rest_steps], head, tails}) do
    head = move_head(direction, head)

    {tails, _} =
      Enum.map_reduce(tails, head, fn t, h ->
        new_t = move_tail(h, t)
        {new_t, new_t}
      end)

    steps =
      case count do
        1 -> rest_steps
        _ -> [{direction, count - 1} | rest_steps]
      end

    {steps, head, tails}
  end

  def move_head("R", {hx, hy}), do: {hx + 1, hy}
  def move_head("L", {hx, hy}), do: {hx - 1, hy}
  def move_head("U", {hx, hy}), do: {hx, hy + 1}
  def move_head("D", {hx, hy}), do: {hx, hy - 1}

  def move_tail({hx, hy}, {tx, ty}) do
    dx = hx - tx
    dy = hy - ty

    cond do
      abs(dx) < 2 && abs(dy) < 2 -> {tx, ty}
      dx == 0 -> {hx, hy - div(dy, abs(dy))}
      dy == 0 -> {hx - div(dx, abs(dx)), hy}
      abs(dx) > abs(dy) -> {hx - div(dx, abs(dx)), hy}
      abs(dy) > abs(dx) -> {hx, hy - div(dy, abs(dy))}
      abs(dx) == abs(dy) -> {hx - div(dx, abs(dx)), hy - div(dy, abs(dy))}
    end
  end
end
