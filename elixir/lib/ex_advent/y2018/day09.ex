defmodule ExAdvent.Y2018.Day09 do
  alias ExAdvent.Util.CircleZipper, as: CircleZipper

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
    |> elem(1)
    |> Map.values()
    |> Enum.max()
  end

  def play_game(game_parameters) do
    zipper = CircleZipper.new(0)
    initial_state = {zipper, %{}}

    {_, last_marble_value} = game_parameters

    1..last_marble_value
    |> Enum.reduce(initial_state, fn marble, game_state ->
      play_marble(marble, game_state, game_parameters)
    end)
  end

  defp play_marble(marble, game_state, game_parameters = {num_players, _})
       when rem(marble, 23) == 0 do
    # inspect_current_state(game_state, game_parameters)

    {marbles, point_map} = game_state
    current_player = rem(marble, num_players)

    # Remove the marble
    marbles = Enum.reduce(1..7, marbles, fn _, marbles -> CircleZipper.rotate_ccw(marbles) end)
    removed_value = CircleZipper.current_value(marbles)
    marbles = CircleZipper.remove(marbles)

    # Give the player points
    point_map = Map.update(point_map, current_player, marble + removed_value, &(&1 + marble + removed_value))

    {marbles, point_map}
  end

  defp play_marble(marble, game_state, game_parameters) do
    # inspect_current_state(game_state, game_parameters)

    {marbles, point_map} = game_state

    marbles =
      marbles
      |> CircleZipper.rotate_cw()
      |> CircleZipper.insert(marble)

    {marbles, point_map}
  end

  def inspect_current_state(game_state, {num_players, _}) do
    {marbles, point_map} = game_state

    current_marble = CircleZipper.current_value(marbles)
    current_player = rem(current_marble, num_players)
    marbles_list = CircleZipper.to_list(marbles)

    zero_idx = Enum.find_index(marbles_list, &(&1 == 0))

    marbles_str =
      0..(length(marbles_list) - 1)
      |> Enum.map(fn base_idx ->
        idx = rem(base_idx + zero_idx, length(marbles_list))
        value = Enum.at(marbles_list, idx)
        is_current = value == current_marble

        if is_current, do: "(#{value})", else: "#{value}"
      end)
      |> Enum.join(" ")

    IO.puts("[#{current_player}] #{marbles_str}")
    IO.inspect(point_map)

    game_state
  end
end
