defmodule ExAdvent.Y2015.Day09 do
  def solve_part1 do
    input()
    |> find_route_distances()
    |> Enum.min()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> find_route_distances()
    |> Enum.max()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day09")
    |> String.trim()
    |> String.split("\n")
  end

  def find_route_distances(input) do
    {cities, distances} = collect_city_info(input)

    build_combinations(cities)
    |> Enum.map(&calculate_route_distance(&1, distances))
  end

  def collect_city_info(input) do
    input
    |> Enum.reduce({MapSet.new(), %{}}, &parse_line/2)
  end

  def parse_line(input_line, {cities, distances}) do
    result = Regex.named_captures(~r/(?<a>.*) to (?<b>.*) = (?<distance>.*)/, input_line)
    a = result["a"]
    b = result["b"]
    distance = String.to_integer(result["distance"])

    updated_cities = cities |> MapSet.put(a) |> MapSet.put(b)

    updated_distances =
      distances |> Map.put("#{a},#{b}", distance) |> Map.put("#{b},#{a}", distance)

    {updated_cities, updated_distances}
  end

  def build_combinations(set) do
    if MapSet.size(set) == 1 do
      [MapSet.to_list(set)]
    else
      set
      |> Enum.flat_map(fn x ->
        MapSet.delete(set, x)
        |> build_combinations()
        |> Enum.map(fn list -> [x | list] end)
      end)
    end
  end

  def calculate_route_distance(route, distances) do
    route
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> "#{a},#{b}" end)
    |> Enum.map(&Map.get(distances, &1))
    |> Enum.sum()
  end
end
