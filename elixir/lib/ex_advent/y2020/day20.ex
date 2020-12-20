defmodule ExAdvent.Y2020.Day20 do
  def solve_part1 do
    input()
    |> parse_input()
    |> multiply_corner_ids()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_sea_monsters()
    |> List.flatten()
    |> Enum.count(fn ch -> ch == ?# end)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day20")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&parse_tile/1)
  end

  def parse_tile(tile) do
    [heading | lines] = String.split(tile, "\n")
    [_, tile_no] = Regex.run(~r/Tile (\d+):/, heading)

    tile_no = String.to_integer(tile_no)
    lines = Enum.map(lines, &String.to_charlist/1)

    {tile_no, lines}
  end

  def multiply_corner_ids(tiles) do
    find_all_matches(tiles)
    |> Enum.filter(fn {_n, _t, matches} -> Enum.count(matches) == 2 end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(&*/2)
  end

  def find_all_matches(tiles) do
    tiles
    |> Enum.map(fn {tile_no, tile} ->
      matches =
        tiles
        |> Enum.reject(fn {n, _t} -> n == tile_no end)
        |> Enum.filter(fn {_n, t} -> tiles_match?(tile, t) end)

      {tile_no, tile, matches}
    end)
  end

  def tiles_match?(a, b) do
    Enum.any?([:top, :bottom, :left, :right], fn dx ->
      ta = get_border(a, dx)

      Enum.any?([:top, :bottom, :left, :right], fn dy ->
        tb = get_border(b, dy)
        ta == tb || ta == Enum.reverse(tb)
      end)
    end)
  end

  def tile_matches_border?(tile, border) do
    Enum.any?([:top, :bottom, :left, :right], fn dir ->
      tb = get_border(tile, dir)
      border == tb || border == Enum.reverse(tb)
    end)
  end

  def get_border(tile, :top) do
    List.first(tile)
  end

  def get_border(tile, :bottom) do
    List.last(tile)
  end

  def get_border(tile, :left) do
    Enum.map(tile, &List.first/1)
  end

  def get_border(tile, :right) do
    Enum.map(tile, &List.last/1)
  end

  @spec get_coordinates({any, any}, :bottom | :left | :right | :top) :: {any, any}
  def get_coordinates({x, y}, :top) do
    {x, y + 1}
  end

  def get_coordinates({x, y}, :bottom) do
    {x, y - 1}
  end

  def get_coordinates({x, y}, :left) do
    {x - 1, y}
  end

  def get_coordinates({x, y}, :right) do
    {x + 1, y}
  end

  def find_sea_monsters(tiles) do
    image = build_image(tiles)

    0..3
    |> Stream.map(&rotate_grid(image, &1))
    |> Stream.flat_map(fn image ->
      [image, flip_grid(image)]
    end)
    |> Stream.map(fn image ->
      replaced_image = replace_sea_monsters(image)
      {image, replaced_image}
    end)
    |> Stream.filter(fn {original, replaced} -> original != replaced end)
    |> Enum.at(0)
    |> elem(1)
  end

  def build_image(tiles) do
    tiles_per_side = tiles |> Enum.count() |> :math.sqrt() |> floor()
    rows_per_tile = List.first(tiles) |> elem(1) |> Enum.count()

    tile_map = place_tiles(tiles)

    Enum.flat_map(0..(tiles_per_side - 1), fn tile_y ->
      Enum.map(1..(rows_per_tile - 2), fn row_y ->
        Enum.reduce(0..(tiles_per_side - 1), [], fn tile_x, acc ->
          {_, tile} = Map.get(tile_map, {tile_x, tile_y})
          row = Enum.at(tile, row_y) |> Enum.slice(1..(rows_per_tile - 2))
          Enum.concat(acc, row)
        end)
      end)
    end)
  end

  def place_tiles(tiles) do
    grid_size = tiles |> Enum.count() |> :math.sqrt() |> floor()
    matches = find_all_matches(tiles)

    {corner_num, corner_tile, [{_, cn1}, {_, cn2}]} =
      Enum.find(matches, fn {_, _, matched_tiles} -> Enum.count(matched_tiles) == 2 end)

    # Find the corner rotation that has its neighbors to the right and bottom
    rotated_corner_tile =
      0..3
      |> Stream.map(&rotate_grid(corner_tile, &1))
      |> Stream.filter(fn tile ->
        bottom_border = get_border(tile, :bottom)
        right_border = get_border(tile, :right)

        (tile_matches_border?(cn1, bottom_border) && tile_matches_border?(cn2, right_border)) ||
          (tile_matches_border?(cn2, bottom_border) && tile_matches_border?(cn1, right_border))
      end)
      |> Enum.at(0)

    tile_map = %{{0, 0} => {corner_num, rotated_corner_tile}}

    place_tiles(tile_map, grid_size, matches, {0, 0})
  end

  defp place_tiles(tile_map, grid_size, matches, last_coords) do
    {last_number, last_tile} = Map.get(tile_map, last_coords)
    {_, _, last_neighbors} = Enum.find(matches, fn {n, _, _} -> n == last_number end)
    neighbor_coords = get_neighbor_coords(grid_size, last_coords)

    Enum.reduce(
      neighbor_coords,
      {tile_map, last_neighbors},
      fn {coords, direction}, {tile_map, remaining_neighbors} ->
        cond do
          Map.has_key?(tile_map, coords) ->
            {tile_map, remaining_neighbors}

          true ->
            border = get_border(last_tile, direction)
            neighbor_border_dir = opposite_direction(direction)

            {ntile_num, rotated_ntile} =
              remaining_neighbors
              |> Stream.flat_map(fn {ntile_num, ntile} ->
                0..3
                |> Stream.map(&rotate_grid(ntile, &1))
                |> Stream.flat_map(fn grid ->
                  [grid, flip_grid(grid)]
                end)
                |> Stream.filter(fn tile ->
                  border == get_border(tile, neighbor_border_dir)
                end)
                |> Stream.map(&{ntile_num, &1})
              end)
              |> Enum.at(0)

            tile_map = Map.put(tile_map, coords, {ntile_num, rotated_ntile})
            tile_map = place_tiles(tile_map, grid_size, matches, coords)

            remaining_neighbors =
              Enum.reject(remaining_neighbors, fn {n, _} -> n == ntile_num end)

            {tile_map, remaining_neighbors}
        end
      end
    )
    |> elem(0)
  end

  def get_neighbor_coords(grid_size, {x, y}) do
    [{{x + 1, y}, :right}, {{x, y + 1}, :bottom}]
    |> Enum.filter(fn {{x, y}, _} -> x >= 0 && x < grid_size && y >= 0 && y < grid_size end)
  end

  def rotate_grid(grid, 0), do: grid

  def rotate_grid(grid, times) do
    size = Enum.count(grid)

    rotated =
      Enum.map(0..(size - 1), fn x ->
        Enum.map((size - 1)..0, fn y ->
          Enum.at(grid, y) |> Enum.at(x)
        end)
      end)

    rotate_grid(rotated, times - 1)
  end

  def flip_grid(grid) do
    Enum.map(grid, &Enum.reverse/1)
  end

  def opposite_direction(:bottom), do: :top
  def opposite_direction(:top), do: :bottom
  def opposite_direction(:right), do: :left
  def opposite_direction(:left), do: :right

  def replace_sea_monsters(image) do
    row_count = Enum.count(image)

    0..(row_count - 3)
    |> Enum.reduce(image, fn y, image ->
      0..(row_count - 20)
      |> Enum.reduce(image, fn x, image ->
        replace_sea_monster(image, {x, y})
      end)
    end)
  end

  def replace_sea_monster(grid, {grid_x, grid_y}) do
    case has_sea_monster?(grid, {grid_x, grid_y}) do
      true ->
        Enum.reduce(sea_monster_coords(), grid, fn {sea_x, sea_y}, grid ->
          new_row = List.replace_at(Enum.at(grid, grid_y + sea_y), grid_x + sea_x, ?O)
          List.replace_at(grid, grid_y + sea_y, new_row)
        end)

      false ->
        grid
    end
  end

  def has_sea_monster?(grid, {grid_x, grid_y}) do
    Enum.all?(sea_monster_coords(), fn {sea_x, sea_y} ->
      character =
        grid
        |> Enum.at(grid_y + sea_y)
        |> Enum.at(grid_x + sea_x)

      character == ?# || character == ?O
    end)
  end

  # 0                   #
  # 1 #    ##    ##    ###
  # 2  #  #  #  #  #  #
  #   01234567890123456789
  def sea_monster_coords do
    [
      {18, 0},
      {0, 1},
      {5, 1},
      {6, 1},
      {11, 1},
      {12, 1},
      {17, 1},
      {18, 1},
      {19, 1},
      {1, 2},
      {4, 2},
      {7, 2},
      {10, 2},
      {13, 2},
      {16, 2}
    ]
  end
end
