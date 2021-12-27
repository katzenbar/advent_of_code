defmodule ExAdvent.Y2021.Day23 do
  def solve_part1 do
    input()
    |> parse_input()
    |> make_moves()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> add_amphipods_part_2()
    |> make_moves(4)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day23")
  end

  def parse_input(input) do
    rooms =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.slice(2..3)
      |> Enum.map(fn line ->
        line
        |> String.replace("#", " ")
        |> String.split(" ", trim: true)
      end)

    Enum.zip([?A..?D | rooms])
    |> Enum.reduce(%{}, fn {room, cell1, cell0}, map ->
      map
      |> Map.put({:room, to_string([room]), 2}, cell1)
      |> Map.put({:room, to_string([room]), 1}, cell0)
    end)
  end

  def add_amphipods_part_2(starting_position) do
    Enum.reduce(?A..?D, starting_position, fn room_ch, positions ->
      room = to_string([room_ch])
      {amphipod, positions} = Map.pop!(positions, {:room, room, 2})
      Map.put(positions, {:room, room, 4}, amphipod)
    end)
    |> Map.put({:room, "A", 2}, "D")
    |> Map.put({:room, "A", 3}, "D")
    |> Map.put({:room, "B", 2}, "B")
    |> Map.put({:room, "B", 3}, "C")
    |> Map.put({:room, "C", 2}, "A")
    |> Map.put({:room, "C", 3}, "B")
    |> Map.put({:room, "D", 2}, "C")
    |> Map.put({:room, "D", 3}, "A")
  end

  def make_moves(starting_position, room_depth \\ 2) do
    possible_moves_for_spaces = calculate_possible_moves_for_spaces(room_depth)

    estimated_work = calculate_estimated_work_remaining(starting_position, possible_moves_for_spaces)

    states =
      Heap.new(&(elem(&1, 0) < elem(&2, 0)))
      |> Heap.push({
        estimated_work,
        0,
        starting_position,
        ""
      })

    Stream.iterate({states, possible_moves_for_spaces, %{starting_position => estimated_work}}, &make_move/1)
    |> Stream.map(&find_state_in_final_position/1)
    |> Stream.filter(&(&1 != nil))
    |> Enum.at(0)
    |> elem(0)
  end

  def make_move({states, possible_moves_for_cell, visited_positions}) do
    {state, rest} = Heap.split(states)

    next_states =
      get_possible_next_states(state, possible_moves_for_cell)
      |> Enum.filter(fn {_, score, positions, _} -> score < Map.get(visited_positions, positions, 100_000) end)

    visited_positions =
      Enum.reduce(next_states, visited_positions, fn {_, score, positions, _}, visited ->
        Map.update(visited, positions, score, fn v -> min(v, score) end)
      end)

    next_states = Enum.reduce(next_states, rest, fn state, rest -> Heap.push(rest, state) end)

    {next_states, possible_moves_for_cell, visited_positions}
  end

  def get_possible_next_states(state, possible_moves_for_spaces) do
    {estimate, score, positions, moves} = state

    IO.inspect(%{
      estimate: estimate,
      score: score
      # moves: moves,
      # positions: positions
    })

    Enum.flat_map(positions, fn {space, amphipod} ->
      {room_moves, hall_moves} =
        Map.get(elem(possible_moves_for_spaces, 1), space)
        |> Enum.filter(fn path ->
          is_valid_move?(space, path, positions)
        end)
        |> Enum.split_with(fn path ->
          last_space = List.last(path)
          {space_type, _, _} = last_space

          space_type == :room
        end)

      possible_moves = if length(room_moves) > 0, do: room_moves, else: hall_moves

      Enum.map(possible_moves, fn path ->
        score = score + energy_for_move(amphipod, length(path))

        end_space = List.last(path)

        positions =
          positions
          |> Map.delete(space)
          |> Map.put(end_space, amphipod)

        estimated_work_remaining = calculate_estimated_work_remaining(positions, possible_moves_for_spaces)

        moves = moves <> "#{Enum.join(Tuple.to_list(space), " ")} -> #{Enum.join(Tuple.to_list(end_space), " ")}, "

        {estimated_work_remaining + score, score, positions, moves}
      end)
    end)
  end

  def is_valid_move?(start_space, path, positions) do
    amphipod = Map.get(positions, start_space)
    end_space = List.last(path)

    {_, start_room_type, _} = start_space

    target_room_values = Enum.map(1..4, fn room_idx -> Map.get(positions, {:room, amphipod, room_idx}) end)
    unique_room_values = Enum.filter(target_room_values, &(&1 != nil)) |> Enum.uniq()

    # Path must be clear
    path_is_clear =
      Enum.all?(path, fn p ->
        Map.get(positions, p) == nil
      end)

    # Do not move an amphipod who is already in their final position
    in_final_position =
      amphipod == start_room_type && (unique_room_values == [] || unique_room_values == [start_room_type])

    # Do not move an amphipod into a room that doesn't match
    {_, end_room_type, end_room_idx} = end_space
    is_matching_room_or_hall = end_room_type == nil || end_room_type == amphipod

    # Amphipod cannot stop in space 2 of a room if space 1
    next_room_to_pack =
      Enum.with_index(target_room_values, 1)
      |> Enum.filter(&(elem(&1, 0) == nil))
      |> Enum.map(&elem(&1, 1))
      |> Enum.min(&<=/2, fn -> 1 end)

    end_room_has_correct_room_values = unique_room_values == [] || unique_room_values == [end_room_type]

    is_packing_room_right =
      end_room_type != amphipod || (end_room_has_correct_room_values && end_room_idx == next_room_to_pack)

    path_is_clear && !in_final_position && is_matching_room_or_hall && is_packing_room_right
  end

  def calculate_estimated_work_remaining(positions, possible_moves_for_spaces) do
    {room_depth, possible_moves} = possible_moves_for_spaces

    moves_cost =
      positions
      |> Map.to_list()
      |> Enum.filter(&(elem(&1, 1) != nil))
      |> Enum.map(fn
        {{_, amphipod, room_idx}, amphipod} ->
          cond do
            room_idx > 1 && Map.get(positions, {:room, amphipod, 1}) != amphipod ->
              energy_for_move(amphipod, 2 * (room_depth - room_idx + 2))

            true ->
              0
          end

        {space, amphipod} ->
          path_to_room =
            Map.get(possible_moves, space)
            |> Enum.filter(fn path ->
              {_, room_type, _} = List.last(path)
              room_type == amphipod
            end)
            |> Enum.min_by(&length/1)

          energy_for_move(amphipod, length(path_to_room))
      end)
      |> Enum.sum()

    get_out_of_the_way_cost =
      Enum.flat_map(?A..?D, fn room ->
        room = to_string([room])

        Enum.map(1..(room_depth - 1), fn room_idx ->
          amphipod = Map.get(positions, {:room, room, room_idx})
          if amphipod != room, do: energy_for_move(room, room_depth - room_idx), else: 0
        end)
      end)
      |> Enum.sum()

    moves_cost + get_out_of_the_way_cost
  end

  def energy_for_move(amphipod, num_moves) do
    unit_energy =
      case amphipod do
        "A" -> 1
        "B" -> 10
        "C" -> 100
        "D" -> 1000
      end

    unit_energy * num_moves
  end

  defp find_state_in_final_position({states, _, _}) do
    state = Heap.root(states)
    {_, _, positions, _} = state

    is_final =
      positions
      |> Map.to_list()
      |> Enum.all?(fn
        {{:hall, _, _}, amphipod} -> amphipod == nil
        {{:room, room_type, _}, amphipod} -> room_type == amphipod
      end)

    if is_final, do: state, else: nil
  end

  # ====== POSSIBLE MOVES BUILDER =============================================

  def calculate_possible_moves_for_spaces(room_depth \\ 2) do
    connections = build_space_connections(room_depth)

    possible_moves =
      Enum.reduce(Map.keys(connections), %{}, fn space, possible_moves ->
        moves_for_space = possible_moves_for_space(space, connections)
        Map.put(possible_moves, space, moves_for_space)
      end)

    {room_depth, possible_moves}
  end

  defp build_space_connections(room_depth) do
    hall_connections =
      Enum.reduce(1..11, %{}, fn hall_idx, map ->
        key = {:hall, nil, hall_idx}

        left = if hall_idx > 1, do: {:hall, nil, hall_idx - 1}, else: nil
        right = if hall_idx < 11, do: {:hall, nil, hall_idx + 1}, else: nil

        room =
          case hall_idx do
            3 -> {:room, "A", room_depth}
            5 -> {:room, "B", room_depth}
            7 -> {:room, "C", room_depth}
            9 -> {:room, "D", room_depth}
            _ -> nil
          end

        connections = Enum.filter([left, right, room], & &1)

        Map.put(map, key, connections)
      end)

    Enum.reduce(?A..?D, hall_connections, fn room, map ->
      room = to_string([room])

      Enum.reduce(1..room_depth, map, fn room_idx, map ->
        key = {:room, room, room_idx}

        bottom = if room_idx > 1, do: {:room, room, room_idx - 1}, else: nil

        top =
          cond do
            room_idx < room_depth -> {:room, room, room_idx + 1}
            room == "A" -> {:hall, nil, 3}
            room == "B" -> {:hall, nil, 5}
            room == "C" -> {:hall, nil, 7}
            room == "D" -> {:hall, nil, 9}
          end

        connections = Enum.filter([bottom, top], & &1)

        Map.put(map, key, connections)
      end)
    end)
  end

  defp possible_moves_for_space(space, connections) do
    Map.get(connections, space)
    |> Enum.flat_map(&find_possible_moves(&1, space, connections, MapSet.new([space])))
  end

  defp find_possible_moves(space_key, start_key, connections, visited) do
    visited = MapSet.put(visited, space_key)

    next_cells =
      Map.get(connections, space_key)
      |> Enum.filter(fn x -> !MapSet.member?(visited, x) end)
      |> Enum.flat_map(fn x -> find_possible_moves(x, start_key, connections, visited) end)

    cond do
      can_possible_moves_end_here?(start_key, space_key) ->
        if length(next_cells) > 0, do: [[space_key] | Enum.map(next_cells, &[space_key | &1])], else: [[space_key]]

      true ->
        if length(next_cells) > 0, do: Enum.map(next_cells, &[space_key | &1]), else: []
    end
  end

  defp can_possible_moves_end_here?(start_space, end_space) do
    outside_of_rooms = MapSet.new([{:hall, nil, 3}, {:hall, nil, 5}, {:hall, nil, 7}, {:hall, nil, 9}])
    is_hall_outside_of_room = MapSet.member?(outside_of_rooms, end_space)

    {start_type, start_room_type, _} = start_space
    {end_type, end_room_type, _} = end_space
    is_in_same_room = start_type == :room && end_type == :room && start_room_type == end_room_type

    is_hall_to_hall_move = start_type == :hall && end_type == :hall

    !is_hall_outside_of_room && !is_in_same_room && !is_hall_to_hall_move
  end
end
