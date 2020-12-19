defmodule ExAdvent.Y2020.Day18Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day18

  test "parse input" do
    input = ~s"""
    1 + 2 * 3 + 4 * 5 + 6
    1 + (2 * 3) + (4 * (5 + 6))
    2 * 3 + (4 * 5)
    5 + (8 * 3 + 9 + 3 * 4 * 3)
    5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))
    ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
    """

    assert parse_input(input) == [
             [1, :+, 2, :*, 3, :+, 4, :*, 5, :+, 6],
             [1, :+, [2, :*, 3], :+, [4, :*, [5, :+, 6]]],
             [2, :*, 3, :+, [4, :*, 5]],
             [5, :+, [8, :*, 3, :+, 9, :+, 3, :*, 4, :*, 3]],
             [5, :*, 9, :*, [7, :*, 3, :*, 3, :+, 9, :*, 3, :+, [8, :+, 6, :*, 4]]],
             [[[2, :+, 4, :*, 9], :*, [6, :+, 9, :*, 8, :+, 6], :+, 6], :+, 2, :+, 4, :*, 2]
           ]
  end

  test "evaluate_expression - 2" do
    expression = parse_expression("2")
    assert evaluate_expression(expression) == 2
  end

  test "evaluate_expression - 1 + 2" do
    expression = parse_expression("1 + 2")
    assert evaluate_expression(expression) == 3
  end

  test "evaluate_expression - 1 * 2" do
    expression = parse_expression("1 * 2")
    assert evaluate_expression(expression) == 2
  end

  test "evaluate_expression - ((1 * 2))" do
    expression = parse_expression("((1 * 2))")
    assert evaluate_expression(expression) == 2
  end

  test "evaluate_expression - 1 + 2 * 3 + 4 * 5 + 6" do
    expression = parse_expression("1 + 2 * 3 + 4 * 5 + 6")
    assert evaluate_expression(expression) == 71
  end

  test "evaluate_expression - (1 + 2) * 3" do
    expression = parse_expression("(1 + 2) * 3")
    assert evaluate_expression(expression) == 9
  end

  test "evaluate_expression - ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2" do
    expression = parse_expression("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")
    assert evaluate_expression(expression) == 13632
  end

  test "evaluate pt 2 - 1 + 2 * 3 + 4 * 5 + 6" do
    expression =
      "1 + 2 * 3 + 4 * 5 + 6"
      |> parse_expression()
      |> add_parens_around_addition()

    assert evaluate_expression(expression) == 231
  end

  test "evaluate pt 2 - 2 * 3 + (4 * 5)" do
    expression =
      "2 * 3 + (4 * 5)"
      |> parse_expression()
      |> add_parens_around_addition()

    assert evaluate_expression(expression) == 46
  end

  test "evaluate pt 2 - 5 + (8 * 3 + 9 + 3 * 4 * 3)" do
    expression =
      "5 + (8 * 3 + 9 + 3 * 4 * 3)"
      |> parse_expression()
      |> add_parens_around_addition()

    assert evaluate_expression(expression) == 1445
  end

  test "evaluate pt 2 - 5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))" do
    expression =
      "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"
      |> parse_expression()
      |> add_parens_around_addition()

    assert evaluate_expression(expression) == 669_060
  end

  test "remove_parens - (1 + 2) * 3" do
    expression = parse_expression("(1 + 2) * 3")
    assert remove_parens(expression) == [[1, :+, 2], :*, 3]
  end

  test "remove_parens - 1 + ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2" do
    expression = parse_expression("1 + ((2 + 4 * 9) * (6 + (9 * 8) + 6) + 6) + 2 + 4 * 2")

    assert remove_parens(expression) == [
             1,
             :+,
             [[2, :+, 4, :*, 9], :*, [6, :+, [9, :*, 8], :+, 6], :+, 6],
             :+,
             2,
             :+,
             4,
             :*,
             2
           ]
  end

  test "add_parens_around_addition - 2 * 3 + (4 * 5)" do
    expression = parse_expression("2 * 3 + (4 * 5)")

    assert add_parens_around_addition(expression) == [2, :*, [3, :+, [4, :*, 5]]]
  end

  test "add_parens_around_addition - 5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))" do
    expression = parse_expression("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")

    assert add_parens_around_addition(expression) == [
             5,
             :*,
             9,
             :*,
             [7, :*, 3, :*, [[3, :+, 9]], :*, [3, :+, [[[8, :+, 6]], :*, 4]]]
           ]
  end
end
