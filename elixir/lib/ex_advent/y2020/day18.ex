defmodule ExAdvent.Y2020.Day18 do
  def solve_part1 do
    input()
    |> parse_input()
    |> Enum.map(&evaluate_expression/1)
    |> Enum.sum()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> Enum.map(&add_parens_around_addition/1)
    |> Enum.map(&evaluate_expression/1)
    |> Enum.sum()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day18")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_expression/1)
  end

  def parse_expression(expression) do
    expression
    |> String.to_charlist()
    |> Enum.map(fn
      ?( -> ?(
      ?) -> ?)
      ?* -> :*
      ?+ -> :+
      ?\s -> nil
      ch -> ch - ?0
    end)
    |> Enum.filter(& &1)
    |> remove_parens()
  end

  def evaluate_expression(a) when is_integer(a), do: a
  def evaluate_expression([a]) when is_integer(a), do: a
  def evaluate_expression([a]), do: evaluate_expression(a)

  def evaluate_expression([a | [op | [b | rest]]]) do
    value =
      case op do
        :+ -> evaluate_expression(a) + evaluate_expression(b)
        :* -> evaluate_expression(a) * evaluate_expression(b)
      end

    evaluate_expression([value | rest])
  end

  def remove_parens(expression) do
    Enum.chunk_while(
      expression,
      {[], 0},
      fn ch, {characters, depth} ->
        cond do
          ch == ?( && depth == 0 ->
            {:cont, Enum.reverse(characters), {[], 1}}

          ch == ?( ->
            {:cont, {[ch | characters], depth + 1}}

          ch == ?) && depth == 1 ->
            {:cont, [remove_parens(Enum.reverse(characters))], {[], 0}}

          ch == ?) ->
            {:cont, {[ch | characters], depth - 1}}

          true ->
            {:cont, {[ch | characters], depth}}
        end
      end,
      fn {characters, _depth} ->
        {:cont, Enum.reverse(characters), nil}
      end
    )
    |> Enum.flat_map(& &1)
  end

  def add_parens_around_addition(a) when is_integer(a), do: a
  def add_parens_around_addition([a]), do: [a]
  def add_parens_around_addition([]), do: []

  def add_parens_around_addition([a | [op | [b | rest]]]) do
    case op do
      :+ ->
        add_parens_around_addition([
          [add_parens_around_addition(a), op, add_parens_around_addition(b)]
          | rest
        ])

      :* ->
        [
          add_parens_around_addition(a)
          | [op | add_parens_around_addition([add_parens_around_addition(b) | rest])]
        ]
    end
  end
end
