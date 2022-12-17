defmodule ExAdvent.Y2022.Day16 do
  def solve_part1 do
    input()
    |> parse_input()
    |> get_highest_pressure_to_release([{"AA", 30}])
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> get_highest_pressure_to_release([{"AA", 26}, {"AA", 26}])
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day16")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(%{}, fn {valve, flow, conns}, map ->
      Map.put(map, valve, {flow, conns})
    end)
  end

  def parse_line(input) do
    [_, valve, flow, conns_str] =
      Regex.run(~r/^Valve (.+?) has flow rate=(\d+?); tunnels? leads? to valves? (.+)$/, input)

    conns = String.split(conns_str, ", ", trim: true)

    {valve, String.to_integer(flow), conns}
  end

  def find_distances_between_nodes(valve_map) do
    valves = Map.keys(valve_map)

    starting_matrix =
      Enum.reduce(valves, %{}, fn valve, path_map ->
        {_, conns} = Map.get(valve_map, valve)

        Enum.reduce(conns, path_map, fn conn, path_map ->
          Map.put(path_map, {valve, conn}, {1, []})
        end)
      end)

    Enum.reduce(valves, starting_matrix, fn vk, path_map ->
      Enum.reduce(valves, path_map, fn vi, path_map ->
        Enum.reduce(valves, path_map, fn vj, path_map ->
          {ij_dist, _} = Map.get(path_map, {vi, vj}, {10_000, []})
          {ik_dist, ik_path} = Map.get(path_map, {vi, vk}, {10_000, []})
          {kj_dist, _} = Map.get(path_map, {vk, vj}, {10_000, []})

          cond do
            vi == vj ->
              Map.put(path_map, {vi, vi}, {0, []})

            ij_dist > ik_dist + kj_dist ->
              Map.put(path_map, {vi, vj}, {ik_dist + kj_dist, [vk | ik_path]})

            true ->
              path_map
          end
        end)
      end)
    end)
  end

  def get_highest_pressure_to_release(valve_map, actors) do
    distance_map = find_distances_between_nodes(valve_map)

    Enum.flat_map(Map.keys(valve_map), fn a ->
      Enum.map(Map.keys(valve_map), fn b ->
        {{a, b}, distance_map[{a, b}]}
      end)
    end)
    |> Enum.filter(&(elem(&1, 1) == nil))

    valves_to_open =
      valve_map
      |> Map.to_list()
      |> Enum.filter(fn {_, {flow, _}} -> flow > 0 end)
      |> Enum.map(&elem(&1, 0))

    get_paths_recursive({actors, [], valves_to_open}, distance_map)
    |> Stream.map(&elem(&1, 1))
    |> Stream.map(&get_score_for_opened_valves(&1, valve_map))
    |> Enum.max()
  end

  defp get_score_for_opened_valves(valves_to_open, valve_map) do
    valves_to_open
    |> Enum.map(fn {valve, open_time} ->
      {flow, _} = valve_map[valve]
      flow * open_time
    end)
    |> Enum.sum()
  end

  defp get_paths_recursive({actors, opened_valves, closed_valves}, distance_map) do
    Enum.reduce(actors, [{[], opened_valves, closed_valves}], fn {pos, remaining_time}, moves ->
      Enum.flat_map(moves, fn {actors, opened_valves, closed_valves} ->
        options =
          closed_valves
          |> Enum.filter(fn valve ->
            {dist, _} = distance_map[{pos, valve}]
            time = remaining_time - dist - 1
            time >= 0
          end)

        cond do
          options == [] ->
            [{[{pos, remaining_time} | actors], opened_valves, closed_valves}]

          true ->
            Enum.map(options, fn valve_to_open ->
              {dist, _} = distance_map[{pos, valve_to_open}]
              time = remaining_time - dist - 1

              {
                [{valve_to_open, time} | actors],
                [{valve_to_open, time} | opened_valves],
                Enum.filter(closed_valves, &(&1 != valve_to_open))
              }
            end)
        end
      end)
    end)
    |> Enum.flat_map(fn path = {_, move_opened_valves, move_closed_valves} ->
      cond do
        opened_valves == move_opened_valves && closed_valves == move_closed_valves ->
          [path]

        true ->
          get_paths_recursive(path, distance_map)
      end
    end)
  end
end
