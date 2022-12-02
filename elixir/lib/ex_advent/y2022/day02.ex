defmodule ExAdvent.Y2022.Day02 do
  def solve_part1 do
    input()
    |> parse_input()
    |> Enum.map(&score_round/1)
    |> Enum.sum()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> Enum.map(&translate_move_pt2/1)
    |> Enum.map(&score_round/1)
    |> Enum.sum()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day02")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_input_line/1)
  end

  def parse_input_line(line) do
    [theirs, ours] = String.split(line, " ")
    {decode_move(theirs), decode_move(ours)}
  end

  def decode_move("A"), do: :rock
  def decode_move("B"), do: :paper
  def decode_move("C"), do: :scissors
  def decode_move("X"), do: :rock
  def decode_move("Y"), do: :paper
  def decode_move("Z"), do: :scissors
  def decode_move(str), do: str

  def score_round(moves) do
    {theirs, ours} = moves
    shape_score(ours) + outcome_score(theirs, ours)
  end

  def shape_score(:rock), do: 1
  def shape_score(:paper), do: 2
  def shape_score(:scissors), do: 3

  def outcome_score(move, move), do: 3
  def outcome_score(:rock, :paper), do: 6
  def outcome_score(:rock, :scissors), do: 0
  def outcome_score(:paper, :scissors), do: 6
  def outcome_score(:paper, :rock), do: 0
  def outcome_score(:scissors, :rock), do: 6
  def outcome_score(:scissors, :paper), do: 0

  def translate_move_pt2({:rock, :rock}), do: {:rock, :scissors}
  def translate_move_pt2({:paper, :rock}), do: {:paper, :rock}
  def translate_move_pt2({:scissors, :rock}), do: {:scissors, :paper}

  def translate_move_pt2({theirs, :paper}), do: {theirs, theirs}

  def translate_move_pt2({:rock, :scissors}), do: {:rock, :paper}
  def translate_move_pt2({:paper, :scissors}), do: {:paper, :scissors}
  def translate_move_pt2({:scissors, :scissors}), do: {:scissors, :rock}
end
