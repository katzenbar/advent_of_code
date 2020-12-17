defmodule ExAdvent.Y2020.Day17 do
  def solve_part1 do
    input()
    |> parse_input(3)
    |> execute_boot_process()
    |> Enum.count()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input(4)
    |> execute_boot_process()
    |> Enum.count()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day17")
  end

  def parse_input(input, num_dimensions) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      line
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {val, x}, acc ->
        active =
          case val do
            ?. -> false
            ?# -> true
          end

        coords =
          Enum.reduce(3..num_dimensions, [x, y], fn _, acc -> List.insert_at(acc, -1, 0) end)

        Map.put(acc, coords, active)
      end)
    end)
  end

  def execute_boot_process(start_grid) do
    1..6
    |> Enum.reduce(start_grid, fn _, grid ->
      execute_cycle(grid)
    end)
  end

  def execute_cycle(grid) do
    active_coords =
      Enum.reduce(grid, [], fn {coords, value}, acc ->
        case value do
          true -> [coords | acc]
          false -> acc
        end
      end)

    num_dimensions = active_coords |> List.first() |> Enum.count()

    {min_coords, max_coords} =
      0..(num_dimensions - 1)
      |> Enum.map(fn index ->
        active_coords
        |> Enum.map(&Enum.at(&1, index))
        |> Enum.min_max()
      end)
      |> Enum.unzip()

    coords_to_check =
      generate_coordinates_between(
        Enum.map(min_coords, &(&1 - 1)),
        Enum.map(max_coords, &(&1 + 1))
      )

    Enum.reduce(coords_to_check, %{}, fn coords, acc ->
      next_value = get_next_value(grid, coords)

      case next_value do
        true -> Map.put(acc, coords, next_value)
        false -> acc
      end
    end)
  end

  def get_next_value(grid, coords) do
    my_value = Map.get(grid, coords, false)

    neighbors_active =
      generate_coordinates_between(Enum.map(coords, &(&1 - 1)), Enum.map(coords, &(&1 + 1)))
      |> Enum.reject(&(&1 == coords))
      |> Enum.map(fn coords -> Map.get(grid, coords, false) end)
      |> Enum.count(& &1)

    case my_value do
      true ->
        neighbors_active == 2 || neighbors_active == 3

      false ->
        neighbors_active == 3
    end
  end

  def generate_coordinates_between(a, b) do
    Enum.zip(a, b)
    |> Enum.reduce([[]], fn {ax, bx}, acc ->
      Enum.flat_map(acc, fn coord ->
        Enum.map(ax..bx, fn x ->
          List.insert_at(coord, -1, x)
        end)
      end)
    end)
  end
end
