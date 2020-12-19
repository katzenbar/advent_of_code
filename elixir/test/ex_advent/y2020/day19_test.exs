defmodule ExAdvent.Y2020.Day19Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day19

  test "parse input" do
    input = ~s"""
    0: 4 1 5
    1: 2 3 | 3 2
    2: 4 4 | 5 5
    3: 4 5 | 5 4
    4: "a"
    5: "b"

    ababbb
    bababa
    abbbab
    aaabbb
    aaaabbb
    """

    assert parse_input(input) == {
             %{
               0 => [[4, 1, 5]],
               1 => [[2, 3], [3, 2]],
               2 => [[4, 4], [5, 5]],
               3 => [[4, 5], [5, 4]],
               4 => ["a"],
               5 => ["b"]
             },
             ["ababbb", "bababa", "abbbab", "aaabbb", "aaaabbb"]
           }
  end

  test "get_possible_values_for_rule - 4" do
    rules = %{
      0 => [[4, 1, 5]],
      1 => [[2, 3], [3, 2]],
      2 => [[4, 4], [5, 5]],
      3 => [[4, 5], [5, 4]],
      4 => ["a"],
      5 => ["b"]
    }

    assert get_possible_values_for_rule(rules, 4) == rules
  end

  test "get_possible_values_for_rule - 3" do
    rules = %{
      0 => [[4, 1, 5]],
      1 => [[2, 3], [3, 2]],
      2 => [[4, 4], [5, 5]],
      3 => [[4, 5], [5, 4]],
      4 => ["a"],
      5 => ["b"]
    }

    expected = %{
      0 => [[4, 1, 5]],
      1 => [[2, 3], [3, 2]],
      2 => [[4, 4], [5, 5]],
      3 => ["ab", "ba"],
      4 => ["a"],
      5 => ["b"]
    }

    assert get_possible_values_for_rule(rules, 3) == expected
  end

  test "get_possible_values_for_rule - 0" do
    rules = %{
      0 => [[4, 1, 5]],
      1 => [[2, 3], [3, 2]],
      2 => [[4, 4], [5, 5]],
      3 => [[4, 5], [5, 4]],
      4 => ["a"],
      5 => ["b"]
    }

    assert get_possible_values_for_rule(rules, 0) == %{
             0 => ["aaaabb", "abbabb", "aaabab", "abbbab", "aabaab", "abaaab", "aabbbb", "ababbb"],
             1 => ["aaab", "bbab", "aaba", "bbba", "abaa", "baaa", "abbb", "babb"],
             2 => ["aa", "bb"],
             3 => ["ab", "ba"],
             4 => ["a"],
             5 => ["b"]
           }
  end

  test "find_completely_matching_messages" do
    input = {
      %{
        0 => [[4, 1, 5]],
        1 => [[2, 3], [3, 2]],
        2 => [[4, 4], [5, 5]],
        3 => [[4, 5], [5, 4]],
        4 => ["a"],
        5 => ["b"]
      },
      ["ababbb", "bababa", "abbbab", "aaabbb", "aaaabbb"]
    }

    assert find_completely_matching_messages(input, 0) == ["ababbb", "abbbab"]
  end

  test "find_completely_matching_messages_pt2" do
    input = ~s"""
    42: 9 14 | 10 1
    9: 14 27 | 1 26
    10: 23 14 | 28 1
    1: "a"
    11: 42 31
    5: 1 14 | 15 1
    19: 14 1 | 14 14
    12: 24 14 | 19 1
    16: 15 1 | 14 14
    31: 14 17 | 1 13
    6: 14 14 | 1 14
    2: 1 24 | 14 4
    0: 8 11
    13: 14 3 | 1 12
    15: 1 | 14
    17: 14 2 | 1 7
    23: 25 1 | 22 14
    28: 16 1
    4: 1 1
    20: 14 14 | 1 15
    3: 5 14 | 16 1
    27: 1 6 | 14 18
    14: "b"
    21: 14 1 | 1 14
    25: 1 1 | 1 14
    22: 14 14
    8: 42
    26: 14 22 | 1 20
    18: 15 15
    7: 14 5 | 1 21
    24: 14 1

    abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
    bbabbbbaabaabba
    babbbbaabbbbbabbbbbbaabaaabaaa
    aaabbbbbbaaaabaababaabababbabaaabbababababaaa
    bbbbbbbaaaabbbbaaabbabaaa
    bbbababbbbaaaaaaaabbababaaababaabab
    ababaaaaaabaaab
    ababaaaaabbbaba
    baabbaaaabbaaaababbaababb
    abbbbabbbbaaaababbbbbbaaaababb
    aaaaabbaabaaaaababaa
    aaaabbaaaabbaaa
    aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
    babaaabbbaaabaababbaabababaaab
    aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
    """

    result = input |> parse_input() |> find_completely_matching_messages_pt2()

    assert result == [
             "bbabbbbaabaabba",
             "babbbbaabbbbbabbbbbbaabaaabaaa",
             "aaabbbbbbaaaabaababaabababbabaaabbababababaaa",
             "bbbbbbbaaaabbbbaaabbabaaa",
             "bbbababbbbaaaaaaaabbababaaababaabab",
             "ababaaaaaabaaab",
             "ababaaaaabbbaba",
             "baabbaaaabbaaaababbaababb",
             "abbbbabbbbaaaababbbbbbaaaababb",
             "aaaaabbaabaaaaababaa",
             "aaaabbaabbaaaaaaabbbabbbaaabbaabaaa",
             "aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba"
           ]
  end
end
