defmodule ExAdvent.Y2022.Day14 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_num_sands_to_abyss()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_safe_floor_spot()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day14")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(%{}, &parse_input_line/2)
    |> add_bounding_box()
  end

  def parse_input_line(line, rock_map) do
    line
    |> String.split(" -> ")
    |> Enum.map(fn coords_str ->
      coords_str
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
    |> add_rocks_to_map(rock_map)
  end

  def add_rocks_to_map(rock_path, rock_map) do
    rock_path
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(rock_map, fn [[ax, ay], [bx, by]], rock_map ->
      Enum.reduce(ax..bx, rock_map, fn x, rock_map ->
        Enum.reduce(ay..by, rock_map, fn y, rock_map ->
          Map.put(rock_map, {x, y}, :rock)
        end)
      end)
    end)
  end

  def add_bounding_box(rock_map) do
    {min_x, max_x} =
      rock_map
      |> Map.keys()
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    {min_y, max_y} =
      rock_map
      |> Map.keys()
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max()

    {rock_map, %{"min_x" => min_x, "max_x" => max_x, "min_y" => min_y, "max_y" => max_y}}
  end

  def print_map(rock_map, _) do
    {_, %{"min_x" => min_x, "max_x" => max_x, "max_y" => max_y}} = add_bounding_box(rock_map)

    map =
      Enum.map(0..max_y, fn y ->
        Enum.map(min_x..max_x, fn x ->
          case Map.get(rock_map, {x, y}) do
            nil -> "."
            :rock -> "#"
            :sand -> "o"
          end
        end)
        |> Enum.join("")
      end)
      |> Enum.join("\n")

    map <> "\n"
  end

  def find_num_sands_to_abyss({rock_map, bb}) do
    %{"max_y" => max_y} = bb

    count =
      Stream.iterate({:cont, rock_map}, fn {_, rock_map} ->
        drop_sand(rock_map, max_y + 2, max_y)
      end)
      # |> Stream.each(fn {_, v} -> print_map(v, bb) |> IO.puts() end)
      |> Enum.take_while(fn {status, _} -> status == :cont end)
      |> Enum.count()

    # Remove the first (empty) value from the count
    count - 1
  end

  def find_safe_floor_spot({rock_map, bb}) do
    %{"max_y" => max_y} = bb

    count =
      Stream.iterate({:cont, rock_map}, fn {_, rock_map} ->
        drop_sand(rock_map, max_y + 2, max_y + 2)
      end)
      # |> Stream.each(fn {_, v} -> print_map(v, bb) |> IO.puts() end)
      |> Enum.take_while(fn {status, _} -> status == :cont end)
      |> Enum.count()

    count
  end

  def drop_sand(rock_map, floor_y, max_y, {x, y} \\ {500, 0}) do
    cond do
      y + 1 > max_y ->
        {:halt, rock_map}

      y + 1 == floor_y ->
        {:cont, Map.put(rock_map, {x, y}, :sand)}

      !Map.has_key?(rock_map, {x, y + 1}) ->
        drop_sand(rock_map, floor_y, max_y, {x, y + 1})

      !Map.has_key?(rock_map, {x - 1, y + 1}) ->
        drop_sand(rock_map, floor_y, max_y, {x - 1, y + 1})

      !Map.has_key?(rock_map, {x + 1, y + 1}) ->
        drop_sand(rock_map, floor_y, max_y, {x + 1, y + 1})

      x == 500 && y == 0 ->
        {:halt, Map.put(rock_map, {x, y}, :sand)}

      true ->
        {:cont, Map.put(rock_map, {x, y}, :sand)}
    end
  end
end
