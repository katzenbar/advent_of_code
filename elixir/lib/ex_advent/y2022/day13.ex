defmodule ExAdvent.Y2022.Day13 do
  def solve_part1 do
    input()
    |> parse_input()
    |> get_correct_pair_indices()
    |> Enum.sum()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> get_decoder_key()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day13")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn pair_input ->
      pair_input
      |> String.split("\n")
      |> Enum.map(fn packet_input ->
        packet_input
        |> Code.eval_string()
        |> elem(0)
      end)
    end)
  end

  def get_correct_pair_indices(pairs) do
    pairs
    |> Enum.with_index(1)
    |> Enum.filter(fn {pair, _} ->
      check_pair_order(pair) != false
    end)
    |> Enum.map(&elem(&1, 1))
  end

  def get_decoder_key(pairs) do
    [[[[2]], [[6]]] | pairs]
    |> Enum.flat_map(& &1)
    |> Enum.sort_by(& &1, fn a, b -> check_pair_order([a, b]) end)
    |> Enum.with_index(1)
    |> Enum.filter(fn {packet, _} -> packet == [[2]] || packet == [[6]] end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.product()
  end

  def check_pair_order([left, right]) when is_integer(left), do: check_pair_order([[left], right])
  def check_pair_order([left, right]) when is_integer(right), do: check_pair_order([left, [right]])

  def check_pair_order([left, right]) do
    result =
      Enum.reduce_while(Enum.zip(left, right), nil, fn {l, r}, _ ->
        cond do
          is_list(l) || is_list(r) ->
            result = check_pair_order([l, r])
            if result == nil, do: {:cont, nil}, else: {:halt, result}

          l < r ->
            {:halt, true}

          l > r ->
            {:halt, false}

          true ->
            {:cont, nil}
        end
      end)

    cond do
      is_boolean(result) -> result
      length(left) == length(right) -> nil
      true -> length(left) < length(right)
    end
  end
end
