defmodule ExAdvent.Y2020.Day24 do
  def solve_part1 do
    input()
    |> parse_input()
    |> flip_tiles_for_directions()
    |> MapSet.size()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> flip_tiles_for_days(100)
    |> MapSet.size()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day24")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(""), do: []
  def parse_line("sw" <> rest), do: [:sw | parse_line(rest)]
  def parse_line("w" <> rest), do: [:w | parse_line(rest)]
  def parse_line("nw" <> rest), do: [:nw | parse_line(rest)]
  def parse_line("se" <> rest), do: [:se | parse_line(rest)]
  def parse_line("e" <> rest), do: [:e | parse_line(rest)]
  def parse_line("ne" <> rest), do: [:ne | parse_line(rest)]

  def get_tile_coordinates(directions, starting_coords \\ {0, 0, 0}) do
    Enum.reduce(directions, starting_coords, fn direction, {x, y, z} ->
      case direction do
        :e -> {x + 1, y - 1, z}
        :w -> {x - 1, y + 1, z}
        :ne -> {x + 1, y, z - 1}
        :sw -> {x - 1, y, z + 1}
        :nw -> {x, y + 1, z - 1}
        :se -> {x, y - 1, z + 1}
      end
    end)
  end

  def flip_tiles_for_directions(tiles_to_flip) do
    Enum.reduce(tiles_to_flip, MapSet.new(), fn tile_directions, black_tiles ->
      tile_coords = get_tile_coordinates(tile_directions)

      case MapSet.member?(black_tiles, tile_coords) do
        true -> MapSet.delete(black_tiles, tile_coords)
        false -> MapSet.put(black_tiles, tile_coords)
      end
    end)
  end

  def flip_tiles_for_days(initial_directions, num_days) do
    Enum.reduce(1..num_days, flip_tiles_for_directions(initial_directions), fn _, black_tiles ->
      flip_tiles_for_day(black_tiles)
    end)
  end

  def flip_tiles_for_day(black_tiles) do
    tiles_to_check =
      black_tiles
      |> MapSet.to_list()
      |> Enum.flat_map(&get_tile_neighbors/1)
      |> MapSet.new()

    Enum.reduce(tiles_to_check, MapSet.new(), fn coords, next_black_tiles ->
      black_neighbors = coords |> get_tile_neighbors() |> Enum.count(&MapSet.member?(black_tiles, &1))

      case MapSet.member?(black_tiles, coords) do
        true ->
          if black_neighbors == 1 || black_neighbors == 2,
            do: MapSet.put(next_black_tiles, coords),
            else: next_black_tiles

        false ->
          if black_neighbors == 2,
            do: MapSet.put(next_black_tiles, coords),
            else: next_black_tiles
      end
    end)
  end

  def get_tile_neighbors(coords) do
    Enum.map([:e, :w, :ne, :nw, :se, :sw], &get_tile_coordinates([&1], coords))
  end
end
