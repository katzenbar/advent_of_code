defmodule ExAdvent.Y2016.Day06Test do
  use ExUnit.Case

  import ExAdvent.Y2016.Day06

  test "parse input" do
    input = ~s"""
    eedadn
    drvtee
    eandsr
    raavrd
    atevrs
    tsrnev
    sdttsa
    rasrtv
    nssdts
    ntnada
    svetve
    tesnvt
    vntsnd
    vrdear
    dvrsen
    enarar
    """

    assert parse_input(input) == [
             "eedadn",
             "drvtee",
             "eandsr",
             "raavrd",
             "atevrs",
             "tsrnev",
             "sdttsa",
             "rasrtv",
             "nssdts",
             "ntnada",
             "svetve",
             "tesnvt",
             "vntsnd",
             "vrdear",
             "dvrsen",
             "enarar"
           ]
  end

  test "most_common_characters_by_column" do
    strings = [
      "eedadn",
      "drvtee",
      "eandsr",
      "raavrd",
      "atevrs",
      "tsrnev",
      "sdttsa",
      "rasrtv",
      "nssdts",
      "ntnada",
      "svetve",
      "tesnvt",
      "vntsnd",
      "vrdear",
      "dvrsen",
      "enarar"
    ]

    assert most_common_characters_by_column(strings, &most_frequent/1) == "easter"
  end

  test "most_frequent" do
    assert most_frequent(["a", "b", "c", "b", "a", "a"]) == "a"
  end

  test "least_frequent" do
    assert least_frequent(["a", "b", "c", "b", "a", "a"]) == "c"
  end
end
