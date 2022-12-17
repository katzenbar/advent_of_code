defmodule ExAdvent.Y2022.Day17 do
  def solve_part1 do
    input()
    |> parse_input()
    |> get_highest_pos_after(2022)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> get_highest_pos_after(1_000_000_000_000)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day17")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("", trim: true)
  end

  def get_highest_pos_after(jets, num_rocks) do
    state = %{}
    highest_positions = [-1, -1, -1, -1, -1, -1, -1]

    rocks = [
      [{2, 0}, {3, 0}, {4, 0}, {5, 0}],
      [{2, 1}, {3, 2}, {3, 1}, {3, 0}, {4, 1}],
      [{2, 0}, {3, 0}, {4, 0}, {4, 1}, {4, 2}],
      [{2, 0}, {2, 1}, {2, 2}, {2, 3}],
      [{2, 0}, {2, 1}, {3, 0}, {3, 1}]
    ]

    {{repeated_id, repeated_heights}, prev_states_rev, _} =
      Stream.iterate({state, highest_positions, 0, 0}, &drop_rock(&1, jets, rocks))
      |> Stream.map(fn {state, highest_positions, jets_idx, rocks_idx} ->
        {encode_state(state) <> ";#{jets_idx};#{rocks_idx}", highest_positions}
      end)
      |> Enum.reduce_while(
        {{"", []}, [], MapSet.new()},
        fn v = {state_id, _}, {_, prev_states_rev, prev_states} ->
          cond do
            MapSet.member?(prev_states, state_id) ->
              {:halt, {v, prev_states_rev, prev_states}}

            true ->
              {:cont, {v, [v | prev_states_rev], MapSet.put(prev_states, state_id)}}
          end
        end
      )

    prev_states = Enum.reverse(prev_states_rev)
    cycle_start_idx = Enum.find_index(prev_states, fn {id, _} -> id == repeated_id end)
    cycle_end_idx = length(prev_states) - 1
    cycle_length = cycle_end_idx - cycle_start_idx + 1

    {_, first_heights} = Enum.at(prev_states, cycle_start_idx)
    cycle_start_height = Enum.max(first_heights)
    cycle_end_height = Enum.max(repeated_heights)

    target_mul = div(num_rocks - cycle_start_idx, cycle_length)
    target_rem = rem(num_rocks - cycle_start_idx, cycle_length)

    {_, target_heights} = Enum.at(prev_states, target_rem + cycle_start_idx)
    target_max_height = Enum.max(target_heights) - cycle_start_height

    target_max_height + target_mul * (cycle_end_height - cycle_start_height) + cycle_start_height + 1
  end

  def drop_rock({state, highest_positions, jets_idx, rocks_idx}, jets, rocks) do
    maxy = Enum.max(highest_positions)
    rock = Enum.at(rocks, rocks_idx)
    rocks_idx = rem(rocks_idx + 1, length(rocks))
    start_pos = Enum.map(rock, fn {x, y} -> {x, y + maxy + 4} end)

    {_, pos, jets_idx} =
      Stream.iterate({:cont, start_pos, jets_idx}, fn {_, pos, jets_idx} ->
        {status, new_pos} =
          pos
          |> move_with_jets(state, Enum.at(jets, jets_idx))
          |> move_down(state)

        jets_idx = rem(jets_idx + 1, length(jets))
        {status, new_pos, jets_idx}
      end)
      |> Stream.drop_while(&(elem(&1, 0) == :cont))
      |> Enum.at(0)

    new_highest_positions =
      highest_positions
      |> Enum.with_index()
      |> Enum.map(fn {hy, hx} ->
        highest_at_x =
          pos
          |> Enum.filter(fn {x, _} -> x == hx end)
          |> Enum.max_by(&elem(&1, 1), &>=/2, fn -> {hx, -1} end)
          |> elem(1)

        max(hy, highest_at_x)
      end)

    state =
      Enum.reduce(pos, state, &add_to_state/2)
      |> clean_state(highest_positions, new_highest_positions)

    {state, new_highest_positions, jets_idx, rocks_idx}
  end

  def move_with_jets(pos, state, ">") do
    new_pos = Enum.map(pos, fn {x, y} -> {x + 1, y} end)
    if Enum.all?(new_pos, fn point = {x, _} -> x < 7 && !position_occupied?(point, state) end), do: new_pos, else: pos
  end

  def move_with_jets(pos, state, "<") do
    new_pos = Enum.map(pos, fn {x, y} -> {x - 1, y} end)
    if Enum.all?(new_pos, fn point = {x, _} -> x >= 0 && !position_occupied?(point, state) end), do: new_pos, else: pos
  end

  def move_down(pos, state) do
    new_pos = Enum.map(pos, fn {x, y} -> {x, y - 1} end)

    if Enum.all?(new_pos, fn point -> !position_occupied?(point, state) && elem(point, 1) >= 0 end),
      do: {:cont, new_pos},
      else: {:halt, pos}
  end

  # === STATE MANAGEMENT FNS ======================================================================

  def get_row(state, y) do
    Map.get(state, y, [false, false, false, false, false, false, false])
  end

  def position_occupied?({x, y}, state) do
    Enum.at(get_row(state, y), x)
  end

  def add_to_state({x, y}, state) do
    row = get_row(state, y)
    new_row = List.replace_at(row, x, true)
    Map.put(state, y, new_row)
  end

  def clean_state(state, prev_highest_positions, new_highest_positions) do
    prev_floor = Enum.min(prev_highest_positions)
    new_floor = Enum.min(new_highest_positions)

    cond do
      prev_floor < new_floor ->
        Enum.reduce(prev_floor..(new_floor - 1), state, fn y, state ->
          Map.delete(state, y)
        end)

      true ->
        state
    end
  end

  def encode_state(state) do
    Map.to_list(state)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.flat_map(fn {_, vals} -> Enum.map(vals, fn v -> if v, do: "#", else: "." end) end)
    |> Enum.join("")
  end
end
