defmodule ExAdvent.Y2022.Day18 do
  def solve_part1 do
    input()
    |> parse_input()
    |> count_total_non_touching_faces()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> count_exterior_faces()
    |> IO.inspect()
  end

  def input do
    File.read!("inputs/y2022/day18")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> MapSet.new()
  end

  def count_total_non_touching_faces(coords_set) do
    coords_set
    |> MapSet.to_list()
    |> Stream.map(&count_non_touching_faces(&1, coords_set))
    |> Enum.sum()
  end

  def count_non_touching_faces({xp, yp, zp}, coords_set) do
    [{-1, 0, 0}, {1, 0, 0}, {0, -1, 0}, {0, 1, 0}, {0, 0, -1}, {0, 0, 1}]
    |> Enum.map(fn {xd, yd, zd} ->
      if MapSet.member?(coords_set, {xp + xd, yp + yd, zp + zd}), do: 0, else: 1
    end)
    |> Enum.sum()
  end

  def find_bounding_box(coords_set) do
    coords_list = MapSet.to_list(coords_set)

    {x_min, x_max} = Enum.map(coords_list, &elem(&1, 0)) |> Enum.min_max()
    {y_min, y_max} = Enum.map(coords_list, &elem(&1, 1)) |> Enum.min_max()
    {z_min, z_max} = Enum.map(coords_list, &elem(&1, 2)) |> Enum.min_max()

    {{x_min - 1, y_min - 1, z_min - 1}, {x_max + 1, y_max + 1, z_max + 1}}
  end

  def count_exterior_faces(coords_set) do
    {min_point = {x_min, y_min, z_min}, {x_max, y_max, z_max}} = find_bounding_box(coords_set)

    Stream.unfold({[min_point], MapSet.new()}, fn {to_visit, visited} ->
      case to_visit do
        [] ->
          nil

        [p = {xp, yp, zp} | to_visit] ->
          {to_visit, faces_touched, visited} =
            Enum.reduce(
              [{-1, 0, 0}, {1, 0, 0}, {0, -1, 0}, {0, 1, 0}, {0, 0, -1}, {0, 0, 1}],
              {to_visit, [], MapSet.put(visited, p)},
              fn {xd, yd, zd}, {to_visit, faces_touched, visited} ->
                point = {x, y, z} = {xp + xd, yp + yd, zp + zd}

                cond do
                  # Out of bounds - do nothing
                  x < x_min || x > x_max || y < y_min || y > y_max || z < z_min || z > z_max ->
                    {to_visit, faces_touched, visited}

                  # Already visited - do nothing
                  MapSet.member?(visited, point) ->
                    {to_visit, faces_touched, visited}

                  # Ran into a face - count it and stop searching in this direction
                  MapSet.member?(coords_set, point) ->
                    {to_visit, [{point, p}, faces_touched], visited}

                  true ->
                    {[point | to_visit], faces_touched, visited}
                end
              end
            )

          {faces_touched, {to_visit, visited}}
      end
    end)
    |> Enum.to_list()
    |> List.flatten()
    |> Enum.uniq()
    |> length()
  end
end
