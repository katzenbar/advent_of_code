defmodule ExAdvent.Y2022.Day02Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day02

  def sample_input() do
    ~s"""
    A Y
    B X
    C Z
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == [{:rock, :paper}, {:paper, :rock}, {:scissors, :scissors}]
  end

  test "score_round - first" do
    assert score_round(parsed_sample_input() |> Enum.at(0)) == 8
  end

  test "score_round - second" do
    assert score_round(parsed_sample_input() |> Enum.at(1)) == 1
  end

  test "score_round - third" do
    assert score_round(parsed_sample_input() |> Enum.at(2)) == 6
  end
end
