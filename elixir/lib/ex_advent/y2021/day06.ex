defmodule ExAdvent.Y2021.Day06 do
  def solve_part1 do
    input()
    |> parse_input()
    |> fish_after_num_days(80)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> fish_after_num_days(256)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day06")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(%{}, fn timer, timer_map ->
      Map.update(timer_map, timer, 1, &(&1 + 1))
    end)
  end

  def fish_after_num_days(fish_timer_map, num_days) do
    simulate_num_days(fish_timer_map, num_days)
    |> Map.values()
    |> Enum.sum()
  end

  def simulate_num_days(fish_timer_map, num_days) do
    Enum.reduce(1..num_days, fish_timer_map, fn _, fish_map ->
      simulate_next_day(fish_map)
    end)
  end

  def simulate_next_day(fish_timer_map) do
    fish_timer_map
    |> Map.to_list()
    |> Enum.reduce(%{}, fn {previous_timer, num_fish}, map ->
      case previous_timer do
        0 ->
          map
          |> Map.update(6, num_fish, &(&1 + num_fish))
          |> Map.put(8, num_fish)

        _ ->
          Map.update(map, previous_timer - 1, num_fish, &(&1 + num_fish))
      end
    end)
  end
end
