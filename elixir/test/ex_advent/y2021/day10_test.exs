defmodule ExAdvent.Y2021.Day10Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day10

  def sample_input() do
    ~s"""
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == [
             "[({(<(())[]>[[{[]{<()<>>",
             "[(()[<>])]({[<{<<[]>>(",
             "{([(<{}[<>[]}>{[]{[(<()>",
             "(((({<>}<{<{<>}{[]{[]{}",
             "[[<[([]))<([[{}[[()]]]",
             "[{[{({}]{}}([{[{{{}}([]",
             "{<[[]]>}<{[{[{[]{()[[[]",
             "[<(<(<(<{}))><([]([]()",
             "<{([([[(<>()){}]>(<<{{",
             "<{([{{}}[<[[[<>{}]]]>[]]"
           ]
  end

  test "parse_line - an invalid line - {([(<{}[<>[]}>{[]{[(<()>" do
    assert parse_line("{([(<{}[<>[]}>{[]{[(<()>") == {:invalid, ?}}
  end

  test "parse_line - a valid line - {()()()}" do
    assert parse_line("{()()()}") == {:remaining, []}
  end

  test "parse_line - an incomplete line - [({(<(())[]>[[{[]{<()<>>" do
    assert parse_line("[({(<(())[]>[[{[]{<()<>>") == {:remaining, '{{[[({(['}
  end

  test "get_syntax_error_score" do
    assert get_syntax_error_score(parsed_sample_input()) == 26397
  end

  test "get_autocomplete_scores" do
    assert get_autocomplete_scores(parsed_sample_input()) == [288_957, 5566, 1_480_781, 995_444, 294]
  end

  test "get_middle_autocomplete_score" do
    assert get_middle_autocomplete_score(parsed_sample_input()) == 288_957
  end
end
