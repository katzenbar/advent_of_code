defmodule ExAdvent.Y2020.Day09Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day09

  test "parse input" do
    input = ~s"""
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
    """

    assert parse_input(input) == [
             35,
             20,
             15,
             25,
             47,
             40,
             62,
             55,
             65,
             95,
             102,
             117,
             150,
             182,
             127,
             219,
             299,
             277,
             309,
             576
           ]
  end

  test "find_first_invalid_number" do
    numbers = [
      35,
      20,
      15,
      25,
      47,
      40,
      62,
      55,
      65,
      95,
      102,
      117,
      150,
      182,
      127,
      219,
      299,
      277,
      309,
      576
    ]

    assert find_first_invalid_number(numbers, 5) == 127
  end

  test "find_contiguous_elements_with_sum" do
    numbers = [
      35,
      20,
      15,
      25,
      47,
      40,
      62,
      55,
      65,
      95,
      102,
      117,
      150,
      182,
      127,
      219,
      299,
      277,
      309,
      576
    ]

    assert find_contiguous_elements_with_sum(numbers, 127) == 62
  end
end
