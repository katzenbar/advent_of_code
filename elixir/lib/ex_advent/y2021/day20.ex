defmodule ExAdvent.Y2021.Day20 do
  def solve_part1 do
    input()
    |> parse_input()
    |> enhance_many_times(2)
    |> count_lit_pixels()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> enhance_many_times(50)
    |> count_lit_pixels()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day20")
  end

  def parse_input(input) do
    [enhancer, image] =
      input
      |> String.trim()
      |> String.split("\n\n")

    enhancer = String.replace(enhancer, "\n", "") |> String.to_charlist()

    image =
      image
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, row_idx}, image_map ->
        line
        |> String.to_charlist()
        |> Enum.with_index()
        |> Enum.reduce(image_map, fn {val, col_idx}, image_map ->
          Map.put(image_map, {col_idx, row_idx}, val)
        end)
      end)

    {enhancer, image, ?.}
  end

  def enhance_many_times(state, times) do
    Enum.reduce(1..times, state, fn _, state ->
      apply_image_enhancement_algorithm(state)
    end)
  end

  def count_lit_pixels({_, image, _}) do
    image
    |> Map.values()
    |> Enum.count(&(&1 == ?#))
  end

  def apply_image_enhancement_algorithm({enhancer, image, background_ch}) do
    existing_pixels = Map.keys(image)
    {min_x, max_x} = existing_pixels |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {min_y, max_y} = existing_pixels |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

    new_image =
      Enum.reduce((min_y - 2)..(max_y + 2), %{}, fn y, new_image ->
        Enum.reduce((min_x - 2)..(max_x + 2), new_image, fn x, new_image ->
          neighbor_coords = get_neighbor_coords({x, y})
          neighbor_values = Enum.map(neighbor_coords, fn coord -> Map.get(image, coord, background_ch) end)

          enhancer_idx =
            neighbor_values
            |> to_string()
            |> String.replace("#", "1")
            |> String.replace(".", "0")
            |> String.to_integer(2)

          enhanced_value = Enum.at(enhancer, enhancer_idx)

          Map.put(new_image, {x, y}, enhanced_value)
        end)
      end)

    new_backgrond_ch =
      case background_ch do
        ?. -> Enum.at(enhancer, 0)
        ?# -> Enum.at(enhancer, 511)
      end

    {enhancer, new_image, new_backgrond_ch}
  end

  defp get_neighbor_coords({x, y}) do
    Enum.flat_map(-1..1, fn yi ->
      Enum.map(-1..1, fn xi ->
        {x + xi, y + yi}
      end)
    end)
  end

  def image_map_to_string(image) do
    keys = Map.keys(image)
    {min_x, max_x} = keys |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {min_y, max_y} = keys |> Enum.map(&elem(&1, 1)) |> Enum.min_max()

    image_str =
      Enum.map(min_y..max_y, fn y ->
        Enum.map(min_x..max_x, fn x ->
          Map.get(image, {x, y}, ?.)
        end)
        |> to_string()
      end)
      |> Enum.join("\n")

    image_str <> "\n"
  end
end
