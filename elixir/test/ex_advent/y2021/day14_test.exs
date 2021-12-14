defmodule ExAdvent.Y2021.Day14Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day14

  def sample_input() do
    ~s"""
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
    """
  end

  def parsed_sample_input(), do: parse_input(sample_input())

  test "parse input" do
    assert parsed_sample_input() ==
             {'NNCB',
              %{
                'BB' => ?N,
                'BC' => ?B,
                'BH' => ?H,
                'BN' => ?B,
                'CB' => ?H,
                'CC' => ?N,
                'CH' => ?B,
                'CN' => ?C,
                'HB' => ?C,
                'HC' => ?B,
                'HH' => ?N,
                'HN' => ?C,
                'NB' => ?B,
                'NC' => ?B,
                'NH' => ?C,
                'NN' => ?C
              }}
  end

  test "calculate_most_vs_least_common - 10" do
    assert calculate_most_vs_least_common(parsed_sample_input(), 10) == 1588
  end

  test "calculate_most_vs_least_common - 40" do
    assert calculate_most_vs_least_common(parsed_sample_input(), 40) == 2_188_189_693_529
  end

  test "calculate_char_counts - 10" do
    assert calculate_char_counts(parsed_sample_input(), 10) == %{66 => 1749, 67 => 298, 72 => 161, 78 => 865}
  end

  test "calculate_char_counts - 40" do
    assert calculate_char_counts(parsed_sample_input(), 40) == %{
             66 => 2_192_039_569_602,
             67 => 6_597_635_301,
             72 => 3_849_876_073,
             78 => 1_096_047_802_353
           }
  end
end
