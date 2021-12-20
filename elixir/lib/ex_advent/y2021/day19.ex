defmodule ExAdvent.Y2021.Day19 do
  def solve_part1 do
    input()
    |> parse_input()
    |> count_beacons()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_scanners_furthest_apart()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day19")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&parse_scanner/1)
  end

  def count_beacons(scanners) do
    scanners
    |> match_beacons()
    |> Enum.map(&elem(&1, 1))
    |> List.flatten()
    |> Enum.uniq()
    |> length()
  end

  def find_scanners_furthest_apart(scanners) do
    scanner_positions =
      scanners
      |> match_beacons()
      |> Enum.map(&elem(&1, 0))

    num_scanners = length(scanner_positions)

    Enum.flat_map(0..(num_scanners - 2), fn idx1 ->
      Enum.map((idx1 + 1)..(num_scanners - 1), fn idx2 ->
        {x1, y1, z1} = Enum.at(scanner_positions, idx1)
        {x2, y2, z2} = Enum.at(scanner_positions, idx2)

        abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)
      end)
    end)
    |> Enum.max()
  end

  def match_beacons(scanners) do
    [reference_points | rest] = scanners

    {checked, matched, []} =
      Stream.iterate({[], [{{0, 0, 0}, reference_points}], rest}, fn {checked_scanners, matched_scanners,
                                                                      unknown_scanners} ->
        IO.inspect(%{
          checked: length(checked_scanners),
          matched: length(matched_scanners),
          unknown: length(unknown_scanners)
        })

        [reference = {_, reference_points} | matched_scanners] = matched_scanners

        {matched_scanners, unknown_scanners} =
          Enum.reduce(unknown_scanners, {matched_scanners, []}, fn points, {matched_scanners, unknown_scanners} ->
            translated_points = move_points_to_reference_frame(reference_points, points)

            cond do
              translated_points == nil ->
                {matched_scanners, [points | unknown_scanners]}

              true ->
                {[translated_points | matched_scanners], unknown_scanners}
            end
          end)

        {[reference | checked_scanners], matched_scanners, unknown_scanners}
      end)
      |> Stream.drop_while(fn {_, _, unknown_scanners} -> length(unknown_scanners) > 0 end)
      |> Enum.at(0)

    Enum.concat(checked, matched)
  end

  def move_points_to_reference_frame(reference_points, points) do
    ref_rel_positions = get_relative_positions_for_points(reference_points)

    points
    |> get_rotations()
    |> Stream.map(fn points ->
      positions = get_relative_positions_for_points(points)

      matching_position =
        Stream.flat_map(ref_rel_positions, fn {ref_point, ref_rel_pos} ->
          Stream.map(positions, fn {dest_point, dest_rel_pos} ->
            {ref_point, dest_point, MapSet.size(MapSet.intersection(ref_rel_pos, dest_rel_pos)) > 11}
          end)
        end)
        |> Enum.find(fn {_, _, match} -> match end)

      case matching_position do
        {{ref_x, ref_y, ref_z}, {dest_x, dest_y, dest_z}, _} ->
          x_off = ref_x - dest_x
          y_off = ref_y - dest_y
          z_off = ref_z - dest_z

          scanner_position = {x_off, y_off, z_off}

          points =
            Enum.map(points, fn {x, y, z} ->
              {x + x_off, y + y_off, z + z_off}
            end)

          {scanner_position, points}

        nil ->
          nil
      end
    end)
    |> Stream.filter(& &1)
    |> Enum.at(0)
  end

  def find_matching_position({ref_point, reference_position}, points) do
    points
    |> get_rotations()
    |> Stream.flat_map(fn points -> get_relative_positions_for_points(points) end)
    |> Stream.filter(fn {_, rel_position} ->
      MapSet.size(MapSet.intersection(reference_position, rel_position)) > 11
    end)
    |> Stream.map(fn {point, _} ->
      {ref_point, point}
    end)
    |> Enum.at(0)
  end

  defp parse_scanner(scanner_input) do
    [_ | coordinates] = String.split(scanner_input, "\n")

    Enum.map(coordinates, fn str ->
      [x, y, z] = String.split(str, ",")

      {
        String.to_integer(x),
        String.to_integer(y),
        String.to_integer(z)
      }
    end)
  end

  def get_relative_positions_for_points(points) do
    Enum.map(points, fn point = {x, y, z} ->
      relative_positions =
        Enum.map(points, fn {rx, ry, rz} ->
          {x - rx, y - ry, z - rz}
        end)
        |> MapSet.new()

      {point, relative_positions}
    end)
  end

  def get_rotations(points) do
    swaps_with_rotations = [
      [{0, 1}, {1, 1}, {2, 1}],
      [{0, 1}, {2, -1}, {1, 1}],
      [{0, 1}, {1, -1}, {2, -1}],
      [{0, 1}, {2, 1}, {1, -1}],
      [{0, -1}, {1, -1}, {2, 1}],
      [{0, -1}, {2, -1}, {1, -1}],
      [{0, -1}, {1, 1}, {2, -1}],
      [{0, -1}, {2, 1}, {1, 1}],
      [{1, 1}, {0, -1}, {2, 1}],
      [{1, 1}, {2, -1}, {0, -1}],
      [{1, 1}, {0, 1}, {2, -1}],
      [{1, 1}, {2, 1}, {0, 1}],
      [{1, -1}, {0, 1}, {2, 1}],
      [{1, -1}, {0, -1}, {2, -1}],
      [{1, -1}, {2, -1}, {0, 1}],
      [{1, -1}, {2, 1}, {0, -1}],
      [{2, 1}, {0, 1}, {1, 1}],
      [{2, 1}, {0, -1}, {1, -1}],
      [{2, 1}, {1, -1}, {0, 1}],
      [{2, 1}, {1, 1}, {0, -1}],
      [{2, -1}, {0, -1}, {1, 1}],
      [{2, -1}, {0, 1}, {1, -1}],
      [{2, -1}, {1, 1}, {0, 1}],
      [{2, -1}, {1, -1}, {0, -1}]
    ]

    Stream.map(swaps_with_rotations, fn rotation ->
      Enum.map(points, fn point ->
        Enum.map(rotation, fn {elem_idx, dir} ->
          dir * elem(point, elem_idx)
        end)
        |> List.to_tuple()
      end)
    end)
  end
end
