defmodule ExAdvent.Y2018.Day08Test do
  use ExUnit.Case

  import ExAdvent.Y2018.Day08

  test "parse input" do
    input = "0 3 10 11 12"
    assert parse_input(input) == [0, 3, 10, 11, 12]
  end

  test "build_tree - example B" do
    assert build_tree([0, 3, 10, 11, 12]) == {[[10, 11, 12]], []}
  end

  test "build_tree - example C" do
    assert build_tree([1, 1, 0, 1, 99, 2]) == {
             [
               [2],
               [
                 [[99]]
               ]
             ],
             []
           }
  end

  test "build_tree - full example" do
    input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
    list = parse_input(input)

    assert build_tree(list) == {
             [
               [1, 1, 2],
               [
                 [[10, 11, 12]],
                 [
                   [2],
                   [
                     [[99]]
                   ]
                 ]
               ]
             ],
             []
           }
  end

  test "sum_metadata" do
    input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
    list = parse_input(input)
    assert sum_metadata(list) == 138
  end

  test "calculate_tree_value - no children" do
    assert calculate_tree_value([[10, 11, 12]]) == {33, [[10, 11, 12]]}
  end

  test "calculate_tree_value - out of range reference" do
    tree = [
      [2],
      [
        [[99]]
      ]
    ]

    assert calculate_tree_value(tree) == {0, [[[99]]]}
  end

  test "calculate_tree_value - recurring references" do
    tree = [
      [1, 1, 2],
      [
        [[10, 11, 12]]
      ]
    ]

    assert calculate_tree_value(tree) == {66, [[[33]]]}
  end

  test "calculate_tree_value - full example" do
    input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
    list = parse_input(input)
    {tree, _} = build_tree(list)
    assert calculate_tree_value(tree) == {66, [[[33]], [[0]]]}
  end
end
