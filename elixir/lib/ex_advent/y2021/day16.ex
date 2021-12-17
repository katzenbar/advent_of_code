defmodule ExAdvent.Y2021.Day16 do
  def solve_part1 do
    input()
    |> parse_input()
    |> sum_version_numbers()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> calculate_value()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day16")
  end

  def parse_input(input) do
    binary_str =
      input
      |> String.trim()
      |> String.to_integer(16)
      |> Integer.to_string(2)

    desired_length = String.length(String.trim(input)) * 4

    binary_str
    |> String.pad_leading(desired_length, "0")
    |> String.to_charlist()
  end

  def sum_version_numbers(charlist) do
    {packet, _} = parse_packet(charlist)

    sum_packet_version_numbers(packet)
  end

  def calculate_value(charlist) do
    {packet, _} = parse_packet(charlist)

    get_packet_value(packet)
  end

  defp get_packet_value(%{type_id: :sum, subpackets: subpackets}) do
    subpackets
    |> Enum.map(&get_packet_value/1)
    |> Enum.sum()
  end

  defp get_packet_value(%{type_id: :product, subpackets: subpackets}) do
    subpackets
    |> Enum.map(&get_packet_value/1)
    |> Enum.reduce(&*/2)
  end

  defp get_packet_value(%{type_id: :minimum, subpackets: subpackets}) do
    subpackets
    |> Enum.map(&get_packet_value/1)
    |> Enum.min()
  end

  defp get_packet_value(%{type_id: :maximum, subpackets: subpackets}) do
    subpackets
    |> Enum.map(&get_packet_value/1)
    |> Enum.max()
  end

  defp get_packet_value(%{type_id: :greater_than, subpackets: [sub_a, sub_b]}) do
    if get_packet_value(sub_a) > get_packet_value(sub_b), do: 1, else: 0
  end

  defp get_packet_value(%{type_id: :less_than, subpackets: [sub_a, sub_b]}) do
    if get_packet_value(sub_a) < get_packet_value(sub_b), do: 1, else: 0
  end

  defp get_packet_value(%{type_id: :equal_to, subpackets: [sub_a, sub_b]}) do
    if get_packet_value(sub_a) == get_packet_value(sub_b), do: 1, else: 0
  end

  defp get_packet_value(%{type_id: :literal, value: value}), do: value

  defp sum_packet_version_numbers(%{subpackets: subpackets, version: version}) do
    subpacket_sum =
      subpackets
      |> Enum.map(&sum_packet_version_numbers/1)
      |> Enum.sum()

    version + subpacket_sum
  end

  def parse_packet(charlist) do
    {version, charlist} = Enum.split(charlist, 3)
    {type_id, charlist} = Enum.split(charlist, 3)

    version = String.to_integer(to_string(version), 2)
    type_id = parse_type_id(type_id)

    case type_id do
      :literal ->
        {value, charlist} = parse_literal_value(charlist)
        {%{version: version, type_id: type_id, value: value, subpackets: []}, charlist}

      _ ->
        [length_type_id | charlist] = charlist

        case length_type_id do
          ?0 ->
            {subpackets, charlist} = parse_fixed_length_packet(charlist)
            {%{version: version, type_id: type_id, subpackets: subpackets}, charlist}

          ?1 ->
            {subpackets, charlist} = parse_subpacket_count_packet(charlist)
            {%{version: version, type_id: type_id, subpackets: subpackets}, charlist}
        end
    end
  end

  def parse_type_id(type_id) do
    case String.to_integer(to_string(type_id), 2) do
      0 -> :sum
      1 -> :product
      2 -> :minimum
      3 -> :maximum
      4 -> :literal
      5 -> :greater_than
      6 -> :less_than
      7 -> :equal_to
    end
  end

  def parse_literal_value(charlist) do
    chunks = Enum.chunk_every(charlist, 5)
    split_idx = Enum.find_index(chunks, fn [first | _] -> first == ?0 end)

    {value_chunks, remaining_chunks} = Enum.split(chunks, split_idx + 1)

    value =
      value_chunks
      |> Enum.map(fn [_ | values] -> to_string(values) end)
      |> Enum.join("")
      |> String.to_integer(2)

    remaining_charlist = Enum.concat(remaining_chunks)

    {value, remaining_charlist}
  end

  def parse_fixed_length_packet(charlist) do
    {length_chlist, value_chlist} = Enum.split(charlist, 15)
    length = String.to_integer(to_string(length_chlist), 2)

    {packet_contents, remaining_charlist} = Enum.split(value_chlist, length)

    packet =
      Stream.iterate({[], packet_contents}, fn
        {_, []} ->
          nil

        {packets, packet_contents} ->
          {packet, packet_contents} = parse_packet(packet_contents)

          {List.insert_at(packets, -1, packet), packet_contents}
      end)
      |> Enum.take_while(fn x -> x != nil end)
      |> List.last()
      |> elem(0)

    {packet, remaining_charlist}
  end

  def parse_subpacket_count_packet(charlist) do
    {count_chlist, value_chlist} = Enum.split(charlist, 11)
    count = String.to_integer(to_string(count_chlist), 2)

    Stream.iterate({[], value_chlist}, fn
      {_, []} ->
        nil

      {packets, packet_contents} ->
        {packet, packet_contents} = parse_packet(packet_contents)

        {List.insert_at(packets, -1, packet), packet_contents}
    end)
    |> Enum.take(count + 1)
    |> List.last()
  end
end
