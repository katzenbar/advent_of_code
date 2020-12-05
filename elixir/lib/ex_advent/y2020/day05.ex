defmodule ExAdvent.Y2020.Day05 do
  def solve_part1 do
    input()
    |> parse_input()
    |> Enum.map(&find_seat_id/1)
    |> Enum.max()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> Enum.map(&find_seat_id/1)
    |> find_empty_seat()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day05")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
  end

  def find_seat_position(seat_str) do
    {row, row, col, col} =
      Enum.reduce(
        String.to_charlist(seat_str),
        {0, 127, 0, 7},
        fn ch, {r_min, r_max, c_min, c_max} ->
          case ch do
            ?F -> {r_min, floor((r_min + r_max) / 2), c_min, c_max}
            ?B -> {ceil((r_min + r_max) / 2), r_max, c_min, c_max}
            ?R -> {r_min, r_max, ceil((c_min + c_max) / 2), c_max}
            ?L -> {r_min, r_max, c_min, floor((c_min + c_max) / 2)}
          end
        end
      )

    {row, col}
  end

  def find_seat_id(seat_str) do
    {row, col} = find_seat_position(seat_str)

    row * 8 + col
  end

  def find_empty_seat(seat_ids) do
    {min, max} = Enum.min_max(seat_ids)

    MapSet.difference(MapSet.new(min..max), MapSet.new(seat_ids))
    |> MapSet.to_list()
    |> List.first()
  end
end
