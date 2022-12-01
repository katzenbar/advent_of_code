defmodule ExAdvent.Y2022.Day01Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day01

  def sample_input() do
    ~s"""
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == [[1000, 2000, 3000], [4000], [5000, 6000], [7000, 8000, 9000], [10_000]]
  end

  test "get_calorie_counts" do
    assert get_calorie_counts(parsed_sample_input()) == [
             6000,
             4000,
             11000,
             24000,
             10000
           ]
  end

  test "get_top_three_total" do
    assert get_top_three_total(parsed_sample_input()) == 45_000
  end
end
