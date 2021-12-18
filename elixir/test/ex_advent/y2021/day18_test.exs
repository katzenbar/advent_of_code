defmodule ExAdvent.Y2021.Day18Test do
  use ExUnit.Case

  import ExAdvent.Y2021.Day18

  test "parse_input" do
    input = ~s"""
    [1,1]
    [9,[8,7]]
    """

    assert parse_input(input) == [
             [{1, 0}, {1, 0}],
             [{9, 0}, {8, 1}, {7, 1}]
           ]
  end

  test "parse_snailfish_number - [1,2]" do
    input = "[1,2]"
    assert parse_snailfish_number(input) == [{1, 0}, {2, 0}]
  end

  test "parse_snailfish_number - [9,[8,7]]" do
    input = "[9,[8,7]]"
    assert parse_snailfish_number(input) == [{9, 0}, {8, 1}, {7, 1}]
  end

  test "parse_snailfish_number - [[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]" do
    input = "[[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]"

    assert parse_snailfish_number(input) == [
             {9, 2},
             {3, 3},
             {8, 3},
             {0, 3},
             {9, 3},
             {6, 2},
             {3, 3},
             {7, 3},
             {4, 3},
             {9, 3},
             {3, 1}
           ]
  end

  test "parse_snailfish_number - [[[[[9,8],1],2],3],4]" do
    input = "[[[[[9,8],1],2],3],4]"
    assert parse_snailfish_number(input) == [{9, 4}, {8, 4}, {1, 3}, {2, 2}, {3, 1}, {4, 0}]
  end

  test "convert_flat_list_to_tree - [1,2]" do
    assert convert_flat_list_to_tree(parse_snailfish_number("[1,2]")) == [1, 2]
  end

  test "convert_flat_list_to_tree - [[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]" do
    assert convert_flat_list_to_tree(parse_snailfish_number("[[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]")) == [
             [[9, [3, 8]], [[0, 9], 6]],
             [[[3, 7], [4, 9]], 3]
           ]
  end

  test "explode_snailfish_number - [9,[8,7]] - no splits" do
    result = explode_snailfish_number(parse_snailfish_number("[9,[8,7]]"))
    assert convert_flat_list_to_tree(result) == [9, [8, 7]]
  end

  test "explode_snailfish_number - [[[[[9,8],1],2],3],4] - no left" do
    result = explode_snailfish_number(parse_snailfish_number("[[[[[9,8],1],2],3],4]"))
    assert convert_flat_list_to_tree(result) == [[[[0, 9], 2], 3], 4]
  end

  test "explode_snailfish_number - [7,[6,[5,[4,[3,2]]]]] - no right" do
    result = explode_snailfish_number(parse_snailfish_number("[7,[6,[5,[4,[3,2]]]]]"))
    assert convert_flat_list_to_tree(result) == [7, [6, [5, [7, 0]]]]
  end

  test "explode_snailfish_number - [[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]] - [7,3] explodes, [3,2] waits until next step" do
    result = explode_snailfish_number(parse_snailfish_number("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]"))
    assert convert_flat_list_to_tree(result) == [[3, [2, [8, 0]]], [9, [5, [4, [3, 2]]]]]
  end

  test "split_snailfish_number - [9,[8,7]] - no splits" do
    result = split_snailfish_number(parse_snailfish_number("[9,[8,7]]"))
    assert convert_flat_list_to_tree(result) == [9, [8, 7]]
  end

  test "split_snailfish_number - [9, [15, 7]] - split odd" do
    result = split_snailfish_number([{9, 0}, {15, 1}, {7, 1}])
    assert convert_flat_list_to_tree(result) == [9, [[7, 8], 7]]
  end

  test "split_snailfish_number - [9, [15, 7]] - split even" do
    result = split_snailfish_number([{9, 0}, {12, 1}, {7, 1}])
    assert convert_flat_list_to_tree(result) == [9, [[6, 6], 7]]
  end

  test "reduce_snailfish_number - explodes - [[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]" do
    result = reduce_snailfish_number(parse_snailfish_number("[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]"))
    assert convert_flat_list_to_tree(result) == [[[[0, 7], 4], [7, [[8, 4], 9]]], [1, 1]]
  end

  test "reduce_snailfish_number - splits - [9, [15, 7]]" do
    result = reduce_snailfish_number([{9, 0}, {12, 1}, {7, 1}])
    assert convert_flat_list_to_tree(result) == [9, [[6, 6], 7]]
  end

  test "reduce_snailfish_number - complete - [[[[0,7],4],[[7,8],[6,0]]],[8,1]]" do
    result = reduce_snailfish_number(parse_snailfish_number("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"))
    assert convert_flat_list_to_tree(result) == [[[[0, 7], 4], [[7, 8], [6, 0]]], [8, 1]]
  end

  test "add_snailfish_numbers - [[[[4,3],4],4],[7,[[8,4],9]]] + [1,1]" do
    result =
      add_snailfish_numbers(parse_snailfish_number("[[[[4,3],4],4],[7,[[8,4],9]]]"), parse_snailfish_number("[1,1]"))

    assert convert_flat_list_to_tree(result) == [[[[0, 7], 4], [[7, 8], [6, 0]]], [8, 1]]
  end

  test "sum_list_of_snailfish_numbers - small example" do
    input = ~s"""
    [1,1]
    [2,2]
    [3,3]
    [4,4]
    [5,5]
    [6,6]
    """

    numbers = parse_input(input)
    result = sum_list_of_snailfish_numbers(numbers)

    assert convert_flat_list_to_tree(result) == [[[[5, 0], [7, 4]], [5, 5]], [6, 6]]
  end

  test "sum_list_of_snailfish_numbers - large example" do
    input = ~s"""
    [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
    [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
    [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
    [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
    [7,[5,[[3,8],[1,4]]]]
    [[2,[2,2]],[8,[8,1]]]
    [2,9]
    [1,[[[9,3],9],[[9,0],[0,7]]]]
    [[[5,[7,4]],7],1]
    [[[[4,2],2],6],[8,7]]
    """

    numbers = parse_input(input)
    result = sum_list_of_snailfish_numbers(numbers)

    assert convert_flat_list_to_tree(result) == [[[[8, 7], [7, 7]], [[8, 6], [7, 7]]], [[[0, 7], [6, 6]], [8, 7]]]
  end

  test "get_magnitude - [[1,2],[[3,4],5]]" do
    assert get_magnitude(parse_snailfish_number("[[1,2],[[3,4],5]]")) == 143
  end

  test "get_magnitude - [[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]" do
    assert get_magnitude(parse_snailfish_number("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")) == 3488
  end

  test "find_largest_magnitude_combo" do
    input = ~s"""
    [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
    [[[5,[2,8]],4],[5,[[9,9],0]]]
    [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
    [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
    [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
    [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
    [[[[5,4],[7,7]],8],[[8,3],8]]
    [[9,3],[[9,9],[6,[4,9]]]]
    [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
    [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
    """

    assert find_largest_magnitude_combo(parse_input(input)) == 3993
  end
end
