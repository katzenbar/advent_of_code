defmodule ExAdvent.Y2021.Day08Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day08

  def sample_input() do
    ~s"""
    be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
    edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
    fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
    fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
    aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
    fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
    dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
    bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
    egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
    gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == [
             {
               ["be", "cfbegad", "cbdgef", "fgaecd", "cgeb", "fdcge", "agebfd", "fecdb", "fabcd", "edb"],
               ["fdgacbe", "cefdb", "cefbgd", "gcbe"]
             },
             {
               ["edbfga", "begcd", "cbg", "gc", "gcadebf", "fbgde", "acbgfd", "abcde", "gfcbed", "gfec"],
               ["fcgedb", "cgb", "dgebacf", "gc"]
             },
             {
               ["fgaebd", "cg", "bdaec", "gdafb", "agbcfd", "gdcbef", "bgcad", "gfac", "gcb", "cdgabef"],
               ["cg", "cg", "fdcagb", "cbg"]
             },
             {
               ["fbegcd", "cbd", "adcefb", "dageb", "afcb", "bc", "aefdc", "ecdab", "fgdeca", "fcdbega"],
               ["efabcd", "cedba", "gadfec", "cb"]
             },
             {
               ["aecbfdg", "fbg", "gf", "bafeg", "dbefa", "fcge", "gcbea", "fcaegb", "dgceab", "fcbdga"],
               ["gecf", "egdcabf", "bgf", "bfgea"]
             },
             {
               ["fgeab", "ca", "afcebg", "bdacfeg", "cfaedg", "gcfdb", "baec", "bfadeg", "bafgc", "acf"],
               ["gebdcfa", "ecba", "ca", "fadegcb"]
             },
             {
               ["dbcfg", "fgd", "bdegcaf", "fgec", "aegbdf", "ecdfab", "fbedc", "dacgb", "gdcebf", "gf"],
               ["cefg", "dcbef", "fcge", "gbcadfe"]
             },
             {
               ["bdfegc", "cbegaf", "gecbf", "dfcage", "bdacg", "ed", "bedf", "ced", "adcbefg", "gebcd"],
               ["ed", "bcgafe", "cdgba", "cbgef"]
             },
             {
               ["egadfb", "cdbfeg", "cegd", "fecab", "cgb", "gbdefca", "cg", "fgcdab", "egfdb", "bfceg"],
               ["gbdfcae", "bgc", "cg", "cgb"]
             },
             {
               ["gcafb", "gcf", "dcaebfg", "ecagb", "gf", "abcdeg", "gaef", "cafbge", "fdbac", "fegbdc"],
               ["fgae", "cfgab", "fg", "bagce"]
             }
           ]
  end

  test "count_easy_digits_in_output" do
    assert count_easy_digits_in_output(parsed_sample_input()) == 26
  end

  test "decode_output_segments" do
    line = {
      ["acedgfb", "cdfbe", "gcdfa", "fbcad", "dab", "cefabd", "cdfgeb", "eafb", "cagedb", "ab"],
      ["cdfeb", "fcadb", "cdfeb", "cdbaf"]
    }

    assert decode_output_segments(line) == ["gadbf", "dgcaf", "gadbf", "gafcd"]
  end

  test "convert_segments_to_number" do
    assert convert_segments_to_number(["gadbf", "dgcaf", "gadbf", "gafcd"]) == 5353
  end

  test "sum_input_values" do
    assert sum_input_values(parsed_sample_input()) == 61229
  end
end
