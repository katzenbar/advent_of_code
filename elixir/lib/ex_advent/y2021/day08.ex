defmodule ExAdvent.Y2021.Day08 do
  def solve_part1 do
    input()
    |> parse_input()
    |> count_easy_digits_in_output()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> sum_input_values()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day08")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(input_line) do
    input_line
    |> String.split(" | ")
    |> Enum.map(&String.split(&1, " "))
    |> List.to_tuple()
  end

  def count_easy_digits_in_output(input) do
    input
    |> Enum.flat_map(&elem(&1, 1))
    |> Enum.count(fn str ->
      str_length = String.length(str)

      str_length <= 4 || str_length == 7
    end)
  end

  def sum_input_values(input) do
    input
    |> Enum.map(&convert_note_to_value/1)
    |> Enum.sum()
  end

  def convert_note_to_value(notes_line) do
    notes_line
    |> decode_output_segments()
    |> convert_segments_to_number()
  end

  def decode_output_segments({scrambled_digits, output}) do
    scrambled_char_lists = Enum.map(scrambled_digits, &String.to_charlist/1)

    num_time_appears =
      scrambled_char_lists
      |> List.flatten()
      |> Enum.reduce(%{}, fn ch, count_map ->
        Map.update(count_map, ch, 1, &(&1 + 1))
      end)
      |> Map.to_list()

    # the segments to make a 1
    len_2_list = Enum.find(scrambled_char_lists, &(length(&1) == 2))
    # the segments to make a 7
    len_3_list = Enum.find(scrambled_char_lists, &(length(&1) == 3))
    # the segments to make a 4
    len_4_list = Enum.find(scrambled_char_lists, &(length(&1) == 4))

    a_val =
      len_2_list
      |> Enum.reduce(len_3_list, fn val, list -> List.delete(list, val) end)
      |> List.first()

    {b_val, _} = Enum.find(num_time_appears, fn {_, num_times} -> num_times == 6 end)

    c_val =
      Enum.filter(num_time_appears, fn {_, num_times} -> num_times == 8 end)
      |> Enum.map(&elem(&1, 0))
      |> List.delete(a_val)
      |> List.first()

    {e_val, _} = Enum.find(num_time_appears, fn {_, num_times} -> num_times == 4 end)
    {f_val, _} = Enum.find(num_time_appears, fn {_, num_times} -> num_times == 9 end)

    d_val =
      Enum.reduce([b_val, c_val, f_val], len_4_list, fn val, list -> List.delete(list, val) end)
      |> List.first()

    g_val =
      Enum.filter(num_time_appears, fn {_, num_times} -> num_times == 7 end)
      |> Enum.map(&elem(&1, 0))
      |> List.delete(d_val)
      |> List.first()

    segment_mapping = %{
      a_val => ?a,
      b_val => ?b,
      c_val => ?c,
      d_val => ?d,
      e_val => ?e,
      f_val => ?f,
      g_val => ?g
    }

    output
    |> Enum.map(fn output_digit ->
      output_digit
      |> String.to_charlist()
      |> Enum.map(&Map.get(segment_mapping, &1))
      |> to_string()
    end)
  end

  def convert_segments_to_number(output) do
    segments_to_num_mappings = [
      {MapSet.new([?a, ?b, ?c, ?e, ?f, ?g]), 0},
      {MapSet.new([?c, ?f]), 1},
      {MapSet.new([?a, ?c, ?d, ?e, ?g]), 2},
      {MapSet.new([?a, ?c, ?d, ?f, ?g]), 3},
      {MapSet.new([?b, ?c, ?d, ?f]), 4},
      {MapSet.new([?a, ?b, ?d, ?f, ?g]), 5},
      {MapSet.new([?a, ?b, ?d, ?e, ?f, ?g]), 6},
      {MapSet.new([?a, ?c, ?f]), 7},
      {MapSet.new([?a, ?b, ?c, ?d, ?e, ?f, ?g]), 8},
      {MapSet.new([?a, ?b, ?c, ?d, ?f, ?g]), 9}
    ]

    output
    |> Enum.map(fn digit_str ->
      segement_set =
        digit_str
        |> String.to_charlist()
        |> MapSet.new()

      {_, digit} =
        Enum.find(segments_to_num_mappings, fn {digit_segments, _} ->
          MapSet.equal?(digit_segments, segement_set)
        end)

      digit
    end)
    |> Enum.reduce(0, fn digit, acc ->
      10 * acc + digit
    end)
  end
end
