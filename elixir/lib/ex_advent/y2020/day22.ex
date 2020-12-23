defmodule ExAdvent.Y2020.Day22 do
  def solve_part1 do
    input()
    |> parse_input()
    |> play_crab_combat()
    |> List.flatten()
    |> calculate_winner_score()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> play_recursive_combat()
    |> List.flatten()
    |> calculate_winner_score()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day22")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn player ->
      player
      |> String.split("\n")
      |> Enum.slice(1..-1)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def calculate_winner_score(deck) do
    deck
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {card, index} -> card * index end)
    |> Enum.reduce(&+/2)
  end

  def play_crab_combat(decks = [[], _]), do: decks
  def play_crab_combat(decks = [_, []]), do: decks

  def play_crab_combat([[p1_plays | p1_rest], [p2_plays | p2_rest]]) do
    decks =
      cond do
        p1_plays > p2_plays ->
          p1 = Enum.concat(p1_rest, [p1_plays, p2_plays])
          [p1, p2_rest]

        true ->
          p2 = Enum.concat(p2_rest, [p2_plays, p1_plays])
          [p1_rest, p2]
      end

    play_crab_combat(decks)
  end

  # - Before either player deals a card, if there was a previous round in this game that had exactly the same cards in
  # the same order in the same players' decks, the game instantly ends in a win for player 1. Previous rounds from
  # other games are not considered. (This prevents infinite games of Recursive Combat, which everyone agrees is a
  # bad idea.)
  # - Otherwise, this round's cards must be in a new configuration; the players begin the round by each drawing the
  # top card of their deck as normal.
  # - If both players have at least as many cards remaining in their deck as the value of the card they just drew,
  # the winner of the round is determined by playing a new game of Recursive Combat (see below).
  # - Otherwise, at least one player must not have enough cards left in their deck to recurse; the winner of the
  # round is the player with the higher-value card.

  def play_recursive_combat(decks, previous_game_states \\ MapSet.new())

  def play_recursive_combat(decks = [[], _], _), do: decks
  def play_recursive_combat(decks = [_, []], _), do: decks

  def play_recursive_combat(decks = [p1, p2], previous_game_states) do
    case MapSet.member?(previous_game_states, decks) do
      true ->
        [p1, []]

      false ->
        previous_game_states = MapSet.put(previous_game_states, decks)

        [p1_plays | p1_rest] = p1
        [p2_plays | p2_rest] = p2

        decks =
          case Enum.count(p1_rest) >= p1_plays && Enum.count(p2_rest) >= p2_plays do
            true ->
              sub_decks =
                play_recursive_combat(
                  [
                    Enum.slice(p1_rest, 0..(p1_plays - 1)),
                    Enum.slice(p2_rest, 0..(p2_plays - 1))
                  ],
                  MapSet.new()
                )

              case sub_decks do
                [[], _] ->
                  p2 = Enum.concat(p2_rest, [p2_plays, p1_plays])
                  [p1_rest, p2]

                [_, []] ->
                  p1 = Enum.concat(p1_rest, [p1_plays, p2_plays])
                  [p1, p2_rest]
              end

            false ->
              cond do
                p1_plays > p2_plays ->
                  p1 = Enum.concat(p1_rest, [p1_plays, p2_plays])
                  [p1, p2_rest]

                true ->
                  p2 = Enum.concat(p2_rest, [p2_plays, p1_plays])
                  [p1_rest, p2]
              end
          end

        play_recursive_combat(decks, previous_game_states)
    end
  end
end
