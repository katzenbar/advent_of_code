defmodule ExAdvent.Y2021.Day21 do
  def solve_part1 do
    input()
    |> parse_input()
    |> play_deterministic_dice()
    |> get_losing_score_with_num_rolls()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> play_quantum_dice()
    |> Enum.max()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day21")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [_, position] = String.split(line, ": ")
      String.to_integer(position)
    end)
  end

  def get_losing_score_with_num_rolls({num_rolls, _, players}) do
    losing_score =
      players
      |> Enum.map(fn {_, score} -> score end)
      |> Enum.min()

    losing_score * num_rolls
  end

  def play_deterministic_dice(starting_positions, target_score \\ 1000) do
    players = Enum.map(starting_positions, fn pos -> {pos, 0} end)
    num_players = length(players)

    # {num dice rolls, last rolled player index, [{position, score}]}
    state = {0, num_players - 1, players}

    Stream.cycle(1..100)
    |> Stream.chunk_every(3)
    |> Stream.transform(state, fn rolls, {num_rolls, last_rolled, players} ->
      player_idx = rem(last_rolled + 1, num_players)
      {position, score} = Enum.at(players, player_idx)

      position = get_next_position(position, Enum.sum(rolls))
      score = score + position

      players = List.replace_at(players, player_idx, {position, score})

      state = {num_rolls + 3, player_idx, players}

      {[state], state}
    end)
    |> Stream.filter(fn {_, _, players} ->
      Enum.any?(players, fn {_, score} -> score >= target_score end)
    end)
    |> Enum.at(0)
  end

  def get_next_position(current_position, roll_sum) do
    rem(current_position + roll_sum - 1, 10) + 1
  end

  def play_quantum_dice(starting_positions) do
    players = Enum.map(starting_positions, fn pos -> {pos, 0} end)
    num_players = length(players)

    # {last rolled player index, [{position, score}]}
    {win_counts, _} = play_quantum_dice_recursively({num_players - 1, players}, %{})

    win_counts
  end

  defp play_quantum_dice_recursively(state, cached_states) when is_map_key(cached_states, state) do
    {Map.get(cached_states, state), cached_states}
  end

  defp play_quantum_dice_recursively(state = {last_rolled, players}, cached_states) do
    possible_rolls =
      Enum.flat_map(1..3, fn a ->
        Enum.flat_map(1..3, fn b ->
          Enum.map(1..3, fn c ->
            [a, b, c]
          end)
        end)
      end)
      |> Enum.map(&Enum.sum/1)
      |> Enum.reduce(%{}, fn value, map ->
        Map.update(map, value, 1, &(&1 + 1))
      end)

    num_players = length(players)
    player_idx = rem(last_rolled + 1, num_players)
    {position, score} = Enum.at(players, player_idx)

    {win_counts, cached_states} =
      possible_rolls
      |> Map.to_list()
      |> Enum.reduce({[], cached_states}, fn {rolls, count}, {win_counts, cached_states} ->
        position = get_next_position(position, rolls)
        score = score + position

        cond do
          score >= 21 ->
            wins =
              Enum.map(players, fn _ -> 0 end)
              |> List.replace_at(player_idx, count)

            {[wins | win_counts], cached_states}

          true ->
            players = List.replace_at(players, player_idx, {position, score})
            state = {player_idx, players}

            {wins, cached_states} = play_quantum_dice_recursively(state, cached_states)

            wins = Enum.map(wins, &(&1 * count))

            {[wins | win_counts], cached_states}
        end
      end)

    win_counts =
      win_counts
      |> Enum.zip_with(&Enum.sum/1)
      |> Enum.to_list()

    cached_states = Map.put(cached_states, state, win_counts)

    {win_counts, cached_states}
  end
end
