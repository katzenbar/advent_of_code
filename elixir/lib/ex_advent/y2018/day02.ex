defmodule ExAdvent.Y2018.Day02 do
  def solve_part1 do
    input()
    |> parse_input()
    |> calculate_checksum()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_most_common_letters()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2018/day02")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split()
  end

  def character_counts(str) do
    str
    |> String.to_charlist()
    |> Enum.reduce(%{}, fn ch, acc ->
      acc
      |> Map.put_new(ch, 0)
      |> Map.update!(ch, &(&1 + 1))
    end)
  end

  def contains_letter_exactly_n_times?(n, character_count) do
    character_count
    |> Map.values()
    |> Enum.any?(&(&1 == n))
  end

  def calculate_checksum(box_ids) do
    box_ids
    |> Enum.map(&character_counts/1)
    |> Enum.map(fn ch_count ->
      [
        if(contains_letter_exactly_n_times?(2, ch_count), do: 1, else: 0),
        if(contains_letter_exactly_n_times?(3, ch_count), do: 1, else: 0)
      ]
    end)
    |> Enum.reduce(fn [two, three], [two_acc, three_acc] -> [two_acc + two, three_acc + three] end)
    |> Enum.reduce(&*/2)
  end

  def find_most_common_letters(box_ids) do
    box_ids
    |> build_pairs_stream()
    |> Stream.map(fn {a, b} -> common_id_letters(a, b) end)
    |> Enum.max_by(&String.length/1)
  end

  def common_id_letters(a, b) do
    a_ch = String.to_charlist(a)
    b_ch = String.to_charlist(b)

    Enum.zip(a_ch, b_ch)
    |> Enum.filter(fn {a, b} -> a == b end)
    |> Enum.map(fn {a, _} -> a end)
    |> to_string()
  end

  def build_pairs_stream(list) do
    Stream.transform(list, list, fn el, list ->
      case list do
        [_ | []] ->
          {:halt, list}

        [_ | rest] ->
          {
            Enum.map(rest, &{el, &1}),
            rest
          }
      end
    end)
  end
end
