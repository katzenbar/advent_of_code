defmodule ExAdvent.Y2021.Day25 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_stable_state()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day25")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
  end

  def find_stable_state(map) do
    Stream.iterate(map, &execute_step/1)
    |> Stream.chunk_every(2, 1)
    |> Stream.with_index(1)
    |> Stream.filter(fn {[a, b], _} -> a == b end)
    |> Stream.map(&elem(&1, 1))
    |> Enum.at(0)
  end

  def execute_step(map) do
    map
    |> move_sea_cucumbers_right()
    |> move_sea_cucumbers_down()
  end

  defp move_sea_cucumbers_right(map) do
    Enum.map(map, fn row ->
      Enum.with_index(row)
      |> Enum.map(fn
        {?., idx} ->
          if Enum.at(row, idx - 1) == ?>, do: ?>, else: ?.

        {?>, idx} ->
          if Enum.at(row, rem(idx + 1, length(row))) == ?., do: ?., else: ?>

        {?v, _} ->
          ?v
      end)
    end)
  end

  defp move_sea_cucumbers_down(map) do
    Enum.with_index(map)
    |> Enum.map(fn {row, row_idx} ->
      previous_row = Enum.at(map, row_idx - 1)
      next_row = Enum.at(map, rem(row_idx + 1, length(map)))

      Enum.with_index(row)
      |> Enum.map(fn
        {?., col_idx} ->
          if Enum.at(previous_row, col_idx) == ?v, do: ?v, else: ?.

        {?v, col_idx} ->
          if Enum.at(next_row, col_idx) == ?., do: ?., else: ?v

        {?>, _} ->
          ?>
      end)
    end)
  end
end
