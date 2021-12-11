defmodule ExAdvent.Y2021.Day11 do
  def solve_part1 do
    input()
    |> parse_input()
    |> count_flashes_after_step(100)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_first_step_all_flash()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day11")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split("")
      |> Enum.filter(&(&1 != ""))
      |> Enum.map(&String.to_integer/1)
    end)
    |> build_map_from_lines()
  end

  defp build_map_from_lines(lines) do
    lines
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, row_idx}, map ->
      line
      |> Enum.with_index()
      |> Enum.reduce(map, fn {value, col_idx}, map ->
        Map.put(map, "#{col_idx},#{row_idx}", value)
      end)
    end)
  end

  def count_flashes_after_step(octopus_map, num_steps) do
    Enum.reduce(1..num_steps, {0, octopus_map}, fn _, {num_flashes, octopus_map} ->
      octopus_map = simulate_step(octopus_map)
      num_flashes = num_flashes + Enum.count(Map.values(octopus_map), &(&1 == 0))

      {num_flashes, octopus_map}
    end)
    |> elem(0)
  end

  def find_first_step_all_flash(octopus_map) do
    octopus_map
    |> Stream.iterate(&simulate_step/1)
    |> Stream.take_while(fn map -> Enum.any?(Map.values(map), &(&1 != 0)) end)
    |> Enum.to_list()
    |> Enum.count()
  end

  def simulate_step(octopus_map) do
    octopus_map
    |> add_one_to_each_octopus()
    |> spread_extra_energy()
    |> clear_flashing_octopi()
  end

  defp add_one_to_each_octopus(octopus_map) do
    Enum.reduce(0..9, octopus_map, fn row_idx, octopus_map ->
      Enum.reduce(0..9, octopus_map, fn col_idx, octopus_map ->
        Map.update!(octopus_map, "#{col_idx},#{row_idx}", fn val -> val + 1 end)
      end)
    end)
  end

  defp spread_extra_energy(octopus_map, already_spread \\ MapSet.new()) do
    points_over_nine =
      octopus_map
      |> Map.to_list()
      |> Enum.filter(fn {_, value} -> value > 9 end)
      |> Enum.map(&elem(&1, 0))
      |> MapSet.new()

    points_to_spread = MapSet.difference(points_over_nine, already_spread)

    cond do
      MapSet.size(points_to_spread) > 0 ->
        points_to_spread
        |> Enum.reduce(octopus_map, fn point_str, octopus_map ->
          [col_idx, row_idx] =
            point_str
            |> String.split(",")
            |> Enum.map(&String.to_integer/1)

          [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]]
          |> Enum.reduce(octopus_map, fn [col_off, row_off], octopus_map ->
            key = "#{col_idx + col_off},#{row_idx + row_off}"

            cond do
              Map.has_key?(octopus_map, key) ->
                Map.update!(octopus_map, key, fn val -> val + 1 end)

              true ->
                octopus_map
            end
          end)
        end)
        |> spread_extra_energy(points_over_nine)

      true ->
        octopus_map
    end
  end

  defp clear_flashing_octopi(octopus_map) do
    Enum.reduce(0..9, octopus_map, fn row_idx, octopus_map ->
      Enum.reduce(0..9, octopus_map, fn col_idx, octopus_map ->
        Map.update!(octopus_map, "#{col_idx},#{row_idx}", fn
          val when val > 9 -> 0
          val -> val
        end)
      end)
    end)
  end

  def map_to_string(octopus_map) do
    Enum.map(0..9, fn row_idx ->
      Enum.map(0..9, fn col_idx -> Map.get(octopus_map, "#{col_idx},#{row_idx}") end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
    |> then(&(&1 <> "\n"))
  end
end
