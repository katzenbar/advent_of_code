defmodule ExAdvent.Y2020.Day11 do
  def solve_part1 do
    input()
    |> parse_input()
    |> apply_rules_pt1()
    |> Enum.map(fn row -> Enum.count(row, &(&1 == ?#)) end)
    |> Enum.sum()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> apply_rules_pt2()
    |> Enum.map(fn row -> Enum.count(row, &(&1 == ?#)) end)
    |> Enum.sum()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day11")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
  end

  def apply_rules_pt1(seat_map) do
    next_seat_map = apply_rules_once_pt1(seat_map)
    if next_seat_map == seat_map, do: seat_map, else: apply_rules_pt1(next_seat_map)
  end

  def apply_rules_once_pt1(seat_map) do
    seat_map
    |> Enum.with_index()
    |> Enum.map(fn {seat_row, row_index} ->
      seat_row
      |> Enum.with_index()
      |> Enum.map(fn {seat, column_index} ->
        adjacent_seats = get_adjacent_seats(seat_map, row_index, column_index)
        get_next_seat_pt1(seat, adjacent_seats)
      end)
    end)
  end

  def get_adjacent_seats(seat_map, row_index, column_index) do
    (row_index - 1)..(row_index + 1)
    |> Enum.flat_map(fn row_i ->
      (column_index - 1)..(column_index + 1)
      |> Enum.map(fn col_i ->
        {row_i, col_i}
      end)
    end)
    |> Enum.filter(fn {row_i, col_i} -> !(row_i == row_index && col_i == column_index) end)
    |> Enum.map(fn {row_i, col_i} -> get_seat_at_index(seat_map, row_i, col_i) end)
  end

  def get_seat_at_index(seat_map, row_i, col_i) do
    num_rows = Enum.count(seat_map)
    num_cols = Enum.count(Enum.at(seat_map, 0))

    cond do
      row_i < 0 -> ?.
      col_i < 0 -> ?.
      row_i >= num_rows -> ?.
      col_i >= num_cols -> ?.
      true -> Enum.at(Enum.at(seat_map, row_i), col_i)
    end
  end

  # - If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
  # - If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
  # - Otherwise, the seat's state does not change.
  def get_next_seat_pt1(?., _), do: ?.

  def get_next_seat_pt1(?L, adjacent_seats) do
    case Enum.count(adjacent_seats, &(&1 == ?#)) > 0 do
      true -> ?L
      false -> ?#
    end
  end

  def get_next_seat_pt1(?#, adjacent_seats) do
    case Enum.count(adjacent_seats, &(&1 == ?#)) > 3 do
      true -> ?L
      false -> ?#
    end
  end

  def apply_rules_pt2(seat_map) do
    next_seat_map = apply_rules_once_pt2(seat_map)
    if next_seat_map == seat_map, do: seat_map, else: apply_rules_pt2(next_seat_map)
  end

  def apply_rules_once_pt2(seat_map) do
    seat_map
    |> Enum.with_index()
    |> Enum.map(fn {seat_row, row_index} ->
      seat_row
      |> Enum.with_index()
      |> Enum.map(fn {seat, column_index} ->
        visible_seats = get_visible_seats(seat_map, row_index, column_index)
        get_next_seat_pt2(seat, visible_seats)
      end)
    end)
  end

  def get_visible_seats(seat_map, row_index, column_index) do
    Enum.map(
      [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}],
      fn {row_dir, col_dir} ->
        get_seat_in_direction(seat_map, row_index, column_index, row_dir, col_dir)
      end
    )
  end

  defp get_seat_in_direction(seat_map, row_index, column_index, row_dir, col_dir) do
    num_rows = Enum.count(seat_map)
    num_cols = Enum.count(Enum.at(seat_map, 0))
    row_i = row_index + row_dir
    col_i = column_index + col_dir

    cond do
      row_i < 0 ->
        ?.

      col_i < 0 ->
        ?.

      row_i >= num_rows ->
        ?.

      col_i >= num_cols ->
        ?.

      true ->
        case Enum.at(Enum.at(seat_map, row_i), col_i) do
          ?. -> get_seat_in_direction(seat_map, row_i, col_i, row_dir, col_dir)
          seat -> seat
        end
    end
  end

  # Also, people seem to be more tolerant than you expected: it now takes five or more visible occupied seats
  # for an occupied seat to become empty (rather than four or more from the previous rules). The other rules
  # still apply: empty seats that see no occupied seats become occupied, seats matching no rule don't change,
  # and floor never changes.
  def get_next_seat_pt2(?., _), do: ?.

  def get_next_seat_pt2(?L, adjacent_seats) do
    case Enum.count(adjacent_seats, &(&1 == ?#)) > 0 do
      true -> ?L
      false -> ?#
    end
  end

  def get_next_seat_pt2(?#, adjacent_seats) do
    case Enum.count(adjacent_seats, &(&1 == ?#)) > 4 do
      true -> ?L
      false -> ?#
    end
  end
end
