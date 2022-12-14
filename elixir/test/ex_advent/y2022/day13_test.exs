defmodule ExAdvent.Y2022.Day13Test do
  use ExUnit.Case

  import ExAdvent.Y2022.Day13

  def sample_input() do
    ~s"""
    [1,1,3,1,1]
    [1,1,5,1,1]

    [[1],[2,3,4]]
    [[1],4]

    [9]
    [[8,7,6]]

    [[4,4],4,4]
    [[4,4],4,4,4]

    [7,7,7,7]
    [7,7,7]

    []
    [3]

    [[[]]]
    [[]]

    [1,[2,[3,[4,[5,6,7]]]],8,9]
    [1,[2,[3,[4,[5,6,0]]]],8,9]
    """
  end

  def parsed_sample_input() do
    parse_input(sample_input())
  end

  test "parse input" do
    assert parsed_sample_input() == [
             [[1, 1, 3, 1, 1], [1, 1, 5, 1, 1]],
             [[[1], [2, 3, 4]], [[1], 4]],
             [[9], [[8, 7, 6]]],
             [[[4, 4], 4, 4], [[4, 4], 4, 4, 4]],
             [[7, 7, 7, 7], [7, 7, 7]],
             [[], [3]],
             [[[[]]], [[]]],
             [[1, [2, [3, [4, [5, 6, 7]]]], 8, 9], [1, [2, [3, [4, [5, 6, 0]]]], 8, 9]]
           ]
  end

  test "get_correct_pair_indices" do
    assert get_correct_pair_indices(parsed_sample_input()) == [1, 2, 4, 6]
  end

  test "get_decoder_key" do
    assert get_decoder_key(parsed_sample_input()) == 140
  end

  test "check_pair_order - out of items at the same time" do
    assert check_pair_order([[], []]) == nil
  end

  test "check_pair_order - left out of items first, right order" do
    assert check_pair_order([[], [9]]) == true
  end

  test "check_pair_order - right out of items first, wrong order" do
    assert check_pair_order([[9], []]) == false
  end

  test "check_pair_order - same list" do
    assert check_pair_order([[2, 2], [2, 2]]) == nil
  end

  test "check_pair_order - left shorter" do
    assert check_pair_order([[2], [2, 2]]) == true
  end

  test "check_pair_order - right shorter" do
    assert check_pair_order([[2, 2, 2], [2, 2]]) == false
  end

  test "check_pair_order - example [1,1,3,1,1] [1,1,5,1,1]" do
    assert check_pair_order([[1, 1, 3, 1, 1], [1, 1, 5, 1, 1]]) == true
  end

  test "check_pair_order - example [[1, [2, [3, [4, [5, 6, 7]]]], 8, 9], [1, [2, [3, [4, [5, 6, 0]]]], 8, 9]]" do
    assert check_pair_order([[1, [2, [3, [4, [5, 6, 7]]]], 8, 9], [1, [2, [3, [4, [5, 6, 0]]]], 8, 9]]) == false
  end
end
