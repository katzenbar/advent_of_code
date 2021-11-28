defmodule ExAdvent.Y2018.Day09 do
  @debug false

  def solve_part1 do
    input()
    |> parse_input()
    |> get_winning_score()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> then(fn {num_players, last_marble_value} -> {num_players, 100 * last_marble_value} end)
    |> get_winning_score()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2018/day09")
  end

  def parse_input(input) do
    str =
      input
      |> String.trim()

    Regex.scan(~r/(\d+)/, str)
    |> Enum.map(fn [_full, capture] -> capture end)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def get_winning_score(game_parameters) do
    game_parameters
    |> play_game()
    |> elem(3)
    |> Map.values()
    |> Enum.max()
  end

  def play_game(game_parameters) do
    initial_state = {0, 0, [2, 1, 0], %{}}
    {_, last_marble_value} = game_parameters

    3..last_marble_value
    |> Enum.reduce(initial_state, fn marble, game_state ->
      play_marble(marble, game_state, game_parameters)
    end)
  end

  defp play_marble(marble, game_state, {num_players, _})
       when rem(marble, 23) == 0 do
    # inspect_current_state(game_state)

    {current_marble_index, current_player, marbles, point_map} = game_state

    # Remove the marble
    remove_idx = rem(current_marble_index - 7 + length(marbles), length(marbles))
    removed_value = Enum.at(marbles, remove_idx)
    marbles = List.delete_at(marbles, remove_idx)

    # Give the player points
    point_map = Map.update(point_map, current_player, marble + removed_value, &(&1 + marble + removed_value))

    current_marble_index = remove_idx
    current_player = rem(current_player + 1, num_players)

    {current_marble_index, current_player, marbles, point_map}
  end

  defp play_marble(marble, game_state, {num_players, _}) do
    # inspect_current_state(game_state)

    {current_marble_index, current_player, marbles, point_map} = game_state

    insert_idx =
      case length(marbles) do
        1 -> 1
        _ -> rem(current_marble_index + 2, length(marbles))
      end

    marbles = List.insert_at(marbles, insert_idx, marble)

    current_marble_index = insert_idx
    current_player = rem(current_player + 1, num_players)

    {current_marble_index, current_player, marbles, point_map}
  end

  def inspect_current_state(game_state) do
    {current_marble_index, current_player, marbles, point_map} = game_state

    zero_idx = Enum.find_index(marbles, &(&1 == 0))

    marbles_str =
      0..(length(marbles) - 1)
      |> Enum.map(fn base_idx ->
        idx = rem(base_idx + zero_idx, length(marbles))
        value = Enum.at(marbles, idx)
        is_current = current_marble_index == idx

        if is_current, do: "(#{value})", else: "#{value}"
      end)
      |> Enum.join(" ")

    IO.puts("[#{current_player}] #{marbles_str}")
    IO.inspect(point_map)

    game_state
  end
end
