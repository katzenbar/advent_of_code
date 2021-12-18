defmodule ExAdvent.Y2021.Day18 do
  def solve_part1 do
    input()
    |> parse_input()
    |> sum_list_of_snailfish_numbers()
    |> get_magnitude()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_largest_magnitude_combo()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day18")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_snailfish_number/1)
  end

  def parse_snailfish_number(number) do
    number
    |> String.to_charlist()
    |> parse_snailfish_number_recursively()
    |> elem(0)
  end

  defp parse_snailfish_number_recursively(charlist, level \\ -1)

  defp parse_snailfish_number_recursively([?[ | rest], level) do
    {left, rest} = parse_snailfish_number_recursively(rest, level + 1)
    [?, | rest] = rest
    {right, rest} = parse_snailfish_number_recursively(rest, level + 1)
    [?] | rest] = rest

    {Enum.concat(left, right), rest}
  end

  defp parse_snailfish_number_recursively([num | rest], level) do
    {[{num - ?0, level}], rest}
  end

  def find_largest_magnitude_combo(numbers) do
    len = length(numbers)

    Enum.flat_map(0..(len - 2), fn a_idx ->
      Enum.flat_map((a_idx + 1)..(len - 1), fn b_idx ->
        num_a = Enum.at(numbers, a_idx)
        num_b = Enum.at(numbers, b_idx)

        [
          get_magnitude(add_snailfish_numbers(num_a, num_b)),
          get_magnitude(add_snailfish_numbers(num_b, num_a))
        ]
      end)
    end)
    |> Enum.max()
  end

  def sum_list_of_snailfish_numbers(numbers) do
    Enum.reduce(numbers, fn n, sum ->
      add_snailfish_numbers(sum, n)
    end)
  end

  def add_snailfish_numbers(list_a, list_b) do
    Enum.concat(list_a, list_b)
    |> Enum.map(fn {value, level} -> {value, level + 1} end)
    |> Stream.iterate(&reduce_snailfish_number/1)
    |> Stream.chunk_every(2, 1)
    |> Stream.drop_while(fn [a, b] -> a != b end)
    |> Stream.map(fn [a, _] -> a end)
    |> Enum.at(0)
  end

  def reduce_snailfish_number(number) do
    reduced_number = explode_snailfish_number(number)

    if number == reduced_number, do: split_snailfish_number(number), else: reduced_number
  end

  def explode_snailfish_number(number_list) do
    chunks = Enum.chunk_every(number_list, 2, 1, :discard)

    reduce_idx = Enum.find_index(chunks, fn [{_, l1}, {_, l2}] -> l1 == 4 && l2 == 4 end)

    case reduce_idx do
      nil ->
        number_list

      _ ->
        {left, [{a, _} | [{b, _} | right]]} = Enum.split(number_list, reduce_idx)

        left = List.update_at(left, -1, fn {val, level} -> {val + a, level} end)
        right = List.update_at(right, 0, fn {val, level} -> {val + b, level} end)

        Enum.concat(left, [{0, 3} | right])
    end
  end

  def split_snailfish_number(number_list) do
    split_idx = Enum.find_index(number_list, fn {val, _} -> val > 9 end)

    case split_idx do
      nil ->
        number_list

      _ ->
        {left_list, [{value, level} | right_list]} = Enum.split(number_list, split_idx)
        left_value = floor(value / 2)
        right_value = ceil(value / 2)

        Enum.concat(left_list, [{left_value, level + 1} | [{right_value, level + 1} | right_list]])
    end
  end

  def convert_flat_list_to_tree([{tree, _}]) do
    tree
  end

  def convert_flat_list_to_tree(number_list) do
    max_level =
      number_list
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

    chunks = Enum.chunk_every(number_list, 2, 1, :discard)

    reduce_idx = Enum.find_index(chunks, fn [{_, l1}, {_, l2}] -> l1 == max_level && l2 == max_level end)

    {before, [{a, _} | [{b, _} | rest]]} = Enum.split(number_list, reduce_idx)

    Enum.concat(before, [{[a, b], max_level - 1} | rest])
    |> convert_flat_list_to_tree()
  end

  def get_magnitude(number_list) do
    number_list
    |> convert_flat_list_to_tree()
    |> get_magnitude_tree()
  end

  defp get_magnitude_tree(node) when is_integer(node), do: node

  defp get_magnitude_tree([left, right]) do
    3 * get_magnitude_tree(left) + 2 * get_magnitude_tree(right)
  end
end
