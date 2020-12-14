defmodule ExAdvent.Y2020.Day14 do
  use Bitwise

  def solve_part1 do
    input()
    |> parse_input()
    |> apply_v1_instructions()
    |> sum_values_in_memory()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> apply_v2_instructions()
    |> sum_values_in_memory()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day14")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line("mask = " <> mask) do
    {:mask, mask}
  end

  def parse_line("mem" <> mem) do
    %{"addr" => addr, "value" => value} =
      Regex.named_captures(~r/^\[(?<addr>\d+)\] = (?<value>\d+)$/, mem)

    {:mem, String.to_integer(addr), String.to_integer(value)}
  end

  def apply_v1_instructions(instructions) do
    Enum.reduce(
      instructions,
      {"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", %{}},
      &apply_v1_instruction/2
    )
  end

  def apply_v1_instruction({:mask, mask}, {_, memory}) do
    {mask, memory}
  end

  def apply_v1_instruction({:mem, addr, value}, {mask, memory}) do
    set_high_mask =
      mask
      |> String.replace("X", "0")
      |> String.to_integer(2)

    set_low_mask =
      mask
      |> String.replace("X", "1")
      |> String.to_integer(2)

    masked_value = (value &&& set_low_mask) ||| set_high_mask

    {mask, Map.put(memory, addr, masked_value)}
  end

  def sum_values_in_memory({_, memory}) do
    memory
    |> Map.values()
    |> Enum.sum()
  end

  def apply_v2_instructions(instructions) do
    Enum.reduce(
      instructions,
      {"000000000000000000000000000000000000", %{}},
      &apply_v2_instruction/2
    )
  end

  def apply_v2_instruction({:mask, mask}, {_, memory}) do
    {String.to_charlist(mask), memory}
  end

  def apply_v2_instruction({:mem, addr, value}, {mask, memory}) do
    addresses =
      addr
      |> Integer.to_string(2)
      |> String.pad_leading(36, "0")
      |> String.to_charlist()
      |> Enum.zip(mask)
      |> Enum.reduce([''], fn {v, m}, values ->
        case m do
          ?0 ->
            Enum.map(values, &List.insert_at(&1, -1, v))

          ?1 ->
            Enum.map(values, &List.insert_at(&1, -1, ?1))

          ?X ->
            Enum.flat_map(values, fn value ->
              [List.insert_at(value, -1, ?0), List.insert_at(value, -1, ?1)]
            end)
        end
      end)
      |> Enum.map(fn val -> val |> List.to_string() |> String.to_integer(2) end)

    updated_memory =
      addresses
      |> Enum.reduce(memory, &Map.put(&2, &1, value))

    {mask, updated_memory}
  end
end
