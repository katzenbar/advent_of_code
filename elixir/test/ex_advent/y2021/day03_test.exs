defmodule ExAdvent.Y2021.Day03Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day03

  def sample_input do
    ['00100', '11110', '10110', '10111', '10101', '01111', '00111', '11100', '10000', '11001', '00010', '01010']
  end

  test "parse input" do
    input = ~s"""
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
    """

    assert parse_input(input) == sample_input()
  end

  test "get_power_consumption" do
    assert get_power_consumption(sample_input()) == 198
  end

  test "get_gamma_rate" do
    assert get_gamma_rate(sample_input()) == 22
  end

  test "get_epsilon_rate" do
    assert get_epsilon_rate(sample_input()) == 9
  end

  test "get_oxygen_generator_rating" do
    assert get_oxygen_generator_rating(sample_input()) == 23
  end

  test "get_c02_scrubber_rating" do
    assert get_c02_scrubber_rating(sample_input()) == 10
  end

  test "get_life_support_rating" do
    assert get_life_support_rating(sample_input()) == 230
  end
end
