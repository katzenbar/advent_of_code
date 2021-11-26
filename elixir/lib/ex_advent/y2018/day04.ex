defmodule ExAdvent.Y2018.Day04 do
  def solve_part1 do
    shifts =
      input()
      |> parse_input()

    guard_id = guard_most_minutes_asleep(shifts)
    minute_asleep = minute_asleep_most(guard_id, shifts) |> elem(0)

    IO.puts(guard_id * minute_asleep)
  end

  def solve_part2 do
    shifts =
      input()
      |> parse_input()

    {guard_id, minute_asleep, _} = guard_asleep_most_during_minute(shifts)

    IO.puts(guard_id * minute_asleep)
  end

  def input do
    File.read!("inputs/y2018/day04")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.sort()
    |> Enum.map(&parse_line/1)
    |> group_shifts()
  end

  def parse_line("[" <> <<time::bytes-size(16)>> <> "] falls asleep") do
    {:falls_asleep, get_minute_from_time(time)}
  end

  def parse_line("[" <> <<time::bytes-size(16)>> <> "] wakes up") do
    {:wakes_up, get_minute_from_time(time)}
  end

  def parse_line(input_line) do
    result = Regex.named_captures(~r/Guard #(?<id>\d+)/, input_line)
    {:begins_shift, String.to_integer(result["id"])}
  end

  def get_minute_from_time(time) do
    result = Regex.named_captures(~r/:(?<minute>\d+)/, time)
    String.to_integer(result["minute"], 10)
  end

  def group_shifts(input_lines) do
    chunk_fn = fn element, acc ->
      case element do
        {:begins_shift, new_shift_id} ->
          case acc do
            nil -> {:cont, {new_shift_id, []}}
            {id, times} -> {:cont, {id, Enum.reverse(times)}, {new_shift_id, []}}
          end

        {:falls_asleep, minute} ->
          {id, times} = acc
          {:cont, {id, [[minute] | times]}}

        {:wakes_up, wake_minute} ->
          {id, [[asleep_minute] | times]} = acc
          {:cont, {id, [[asleep_minute, wake_minute] | times]}}
      end
    end

    after_fn = fn {id, times} -> {:cont, {id, Enum.reverse(times)}, {id, []}} end

    Enum.chunk_while(input_lines, nil, chunk_fn, after_fn)
  end

  def guard_most_minutes_asleep(shifts) do
    shifts
    |> Enum.reduce(%{}, fn {id, sleep_intervals}, acc ->
      sleep_duration =
        sleep_intervals
        |> Enum.map(fn [a, b] -> b - a end)
        |> Enum.sum()

      Map.update(acc, id, sleep_duration, &(&1 + sleep_duration))
    end)
    |> Map.to_list()
    |> Enum.max_by(&elem(&1, 1))
    |> elem(0)
  end

  def guard_asleep_most_during_minute(shifts) do
    guard_ids =
      shifts
      |> Enum.filter(fn {_, sleep_intervals} -> length(sleep_intervals) > 0 end)
      |> Enum.map(&elem(&1, 0))
      |> Enum.uniq()

    guard_ids
    |> Enum.map(fn id ->
      {minute, num_times} = minute_asleep_most(id, shifts)
      {id, minute, num_times}
    end)
    |> Enum.max_by(&elem(&1, 2))
  end

  def minute_asleep_most(guard_id, shifts) do
    shifts
    |> Enum.filter(&(elem(&1, 0) == guard_id))
    |> Enum.flat_map(&elem(&1, 1))
    |> Enum.flat_map(fn [a, b] -> a..(b - 1) end)
    |> most_frequent_value()
  end

  def most_frequent_value(list) do
    list
    |> Enum.reduce(%{}, fn val, acc ->
      Map.update(acc, val, 1, &(&1 + 1))
    end)
    |> Map.to_list()
    |> Enum.max_by(&elem(&1, 1))
  end
end
