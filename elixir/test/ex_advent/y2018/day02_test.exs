defmodule ExAdvent.Y2018.Day02Test do
  use ExUnit.Case

  import ExAdvent.Y2018.Day02

  test "parse input" do
    input = ~s"""
    abcdef
    bababc
    abbcde
    abcccd
    aabcdd
    abcdee
    ababab
    """

    assert parse_input(input) == ["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"]
  end

  test "character_counts - abbcde" do
    result = character_counts("abbcde")
    expected = %{97 => 1, 98 => 2, 99 => 1, 100 => 1, 101 => 1}
    assert result == expected
  end

  test "contains_letter_exactly_n_times? - abbcde" do
    character_count = %{97 => 1, 98 => 2, 99 => 1, 100 => 1, 101 => 1}
    assert contains_letter_exactly_n_times?(2, character_count) == true
  end

  test "contains_letter_exactly_n_times? - abcde" do
    character_count = %{97 => 1, 98 => 1, 99 => 1, 100 => 1, 101 => 1}
    assert contains_letter_exactly_n_times?(3, character_count) == false
  end

  test "contains_letter_exactly_n_times? - aabbcde" do
    character_count = %{97 => 2, 98 => 2, 99 => 1, 100 => 1, 101 => 1}
    assert contains_letter_exactly_n_times?(2, character_count) == true
  end

  test "calculate_checksum - sample input" do
    input = ["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"]
    assert calculate_checksum(input) == 12
  end

  test "find_most_common_letters" do
    input =
      ~s"""
      abcde
      fghij
      klmno
      pqrst
      fguij
      axcye
      wvxyz
      """
      |> parse_input()

    assert find_most_common_letters(input) == "fgij"
  end

  test "common_id_letters - fghij fguij" do
    assert common_id_letters("fghij", "fguij") == "fgij"
  end

  test "build_pairs_stream" do
    input =
      ~s"""
      abcde
      fghij
      klmno
      """
      |> parse_input()

    assert build_pairs_stream(input) |> Enum.to_list() == [{"abcde", "fghij"}, {"abcde", "klmno"}, {"fghij", "klmno"}]
  end
end
