defmodule ExAdvent.Y2021.Day22 do
  def solve_part1 do
    input()
    |> parse_input()
    |> filter_steps_within_region(-50..50)
    |> apply_steps()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> apply_steps()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day22")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(input_line) do
    result =
      Regex.named_captures(
        ~r/(?<action>on|off) x=(?<min_x>-?\d+)..(?<max_x>-?\d+),y=(?<min_y>-?\d+)..(?<max_y>-?\d+),z=(?<min_z>-?\d+)..(?<max_z>-?\d+)/,
        input_line
      )

    action = String.to_atom(result["action"])
    min_x = String.to_integer(result["min_x"])
    max_x = String.to_integer(result["max_x"])
    min_y = String.to_integer(result["min_y"])
    max_y = String.to_integer(result["max_y"])
    min_z = String.to_integer(result["min_z"])
    max_z = String.to_integer(result["max_z"])

    {action, [{min_x, max_x}, {min_y, max_y}, {min_z, max_z}]}
  end

  def apply_steps(steps) do
    steps
    |> Enum.reduce([], &apply_reboot_step/2)
    |> Enum.map(&count_points_in_cuboid/1)
    |> Enum.sum()
  end

  def filter_steps_within_region(steps, region) do
    Enum.filter(steps, fn {_, [{min, max} | _]} ->
      Enum.member?(region, min) && Enum.member?(region, max)
    end)
  end

  def apply_reboot_step({action, new_cuboid}, on_cuboids) do
    on_cuboids =
      Enum.flat_map(on_cuboids, fn target_cuboid ->
        break_up_cuboid(target_cuboid, new_cuboid)
      end)

    case action do
      :on -> [new_cuboid | on_cuboids]
      :off -> on_cuboids
    end
  end

  def break_up_cuboid(target_cuboid, new_cuboid) do
    [target_x, target_y, target_z] = target_cuboid
    [new_x, new_y, new_z] = new_cuboid

    {non_overlapping_x, overlapping_x} = overlapping_regions(target_x, new_x)
    {non_overlapping_y, overlapping_y} = overlapping_regions(target_y, new_y)
    {non_overlapping_z, _} = overlapping_regions(target_z, new_z)

    x_cuboids = Enum.map(non_overlapping_x, fn x -> [x, target_y, target_z] end)

    y_cuboids =
      Enum.flat_map(overlapping_x, fn x ->
        Enum.map(non_overlapping_y, fn y ->
          [x, y, target_z]
        end)
      end)

    z_cuboids =
      Enum.flat_map(overlapping_x, fn x ->
        Enum.flat_map(overlapping_y, fn y ->
          Enum.map(non_overlapping_z, fn z ->
            [x, y, z]
          end)
        end)
      end)

    Enum.concat([x_cuboids, y_cuboids, z_cuboids])
  end

  # {not_overlapping_regions, overlapping_regions}
  def overlapping_regions({tmin, tmax}, {min, max}) do
    cond do
      tmin > max || tmax < min -> {[{tmin, tmax}], []}
      tmin >= min && tmax > max -> {[{max + 1, tmax}], [{tmin, max}]}
      tmin < min && tmax <= max -> {[{tmin, min - 1}], [{min, tmax}]}
      tmin < min && tmax > max -> {[{tmin, min - 1}, {max + 1, tmax}], [{min, max}]}
      true -> {[], [{tmin, tmax}]}
    end
  end

  def count_points_in_cuboid(cuboid) do
    cuboid
    |> Enum.map(fn {min, max} -> max - min + 1 end)
    |> Enum.reduce(&*/2)
  end
end
