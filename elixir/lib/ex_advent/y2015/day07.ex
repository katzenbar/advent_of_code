defmodule ExAdvent.Y2015.Day07 do
  use Bitwise

  def solve_part1 do
    input()
    |> signal_for_wire("a")
    |> IO.puts()
  end

  def solve_part2 do
    input = input()

    input
    |> String.trim()
    |> String.split("\n")
    |> build_map()
    |> Map.put("b", signal_for_wire(input, "a"))
    |> value_for_node("a")
    |> elem(1)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day07")
  end

  @spec signal_for_wire(binary, any) :: integer
  def signal_for_wire(input, target) do
    input
    |> String.trim()
    |> String.split("\n")
    |> build_map()
    |> value_for_node(target)
    |> elem(1)
  end

  def build_map(input) do
    input
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(%{}, fn {target, instruction}, map -> Map.put_new(map, target, instruction) end)
  end

  def parse_line(input_line) do
    result = Regex.named_captures(~r/(?<instruction>.*) -> (?<target>.*)/, input_line)
    {result["target"], parse_instruction(result["instruction"])}
  end

  @spec parse_instruction(binary) ::
          {:not, any}
          | {:set, integer}
          | {:and, any, any}
          | {:lshift, any, any}
          | {:or, any, any}
          | {:rshift, any, any}
  def parse_instruction(inst) do
    cond do
      String.contains?(inst, ["AND", "OR"]) -> parse_binary_instruction(inst)
      String.contains?(inst, ["LSHIFT", "RSHIFT"]) -> parse_shift_instruction(inst)
      String.contains?(inst, "NOT") -> parse_not_instruction(inst)
      true -> parse_value_instruction(inst)
    end
  end

  def parse_binary_instruction(inst) do
    result = Regex.named_captures(~r/(?<a>.*) (?<gate>.*) (?<b>.*)/, inst)
    {parse_gate(result["gate"]), result["a"], result["b"]}
  end

  @spec parse_shift_instruction(binary) ::
          {:and, any, integer}
          | {:lshift, any, integer}
          | {:or, any, integer}
          | {:rshift, any, integer}
  def parse_shift_instruction(inst) do
    result = Regex.named_captures(~r/(?<a>.*) (?<gate>.*) (?<amount>.*)/, inst)
    {parse_gate(result["gate"]), result["a"], result["amount"]}
  end

  def parse_not_instruction(inst) do
    result = Regex.named_captures(~r/NOT (?<a>.*)/, inst)
    {:not, result["a"]}
  end

  def parse_value_instruction(instruction) do
    {:value, instruction}
  end

  def parse_gate(gate) do
    case gate do
      "AND" -> :and
      "OR" -> :or
      "LSHIFT" -> :lshift
      "RSHIFT" -> :rshift
    end
  end

  @spec value_for_node(map, any) :: {map, integer}
  def value_for_node(map, node) do
    instruction = Map.get(map, node)

    cond do
      instruction == nil ->
        {map, String.to_integer(node)}

      is_integer(instruction) ->
        {map, instruction}

      true ->
        {updated_map, value} =
          case instruction do
            {:value, a} -> value_for_node(map, a)
            {:and, a, b} -> resolve_binary(map, a, b, &band/2)
            {:or, a, b} -> resolve_binary(map, a, b, &bor/2)
            {:not, a} -> resolve_unary(map, a, &bnot/1)
            {:lshift, a, b} -> resolve_binary(map, a, b, &bsl/2)
            {:rshift, a, b} -> resolve_binary(map, a, b, &bsr/2)
          end

        # Keep everything within 16-bit unsigned
        final_value = Integer.mod(value, 65536)
        final_map = Map.put(updated_map, node, final_value)
        {final_map, final_value}
    end
  end

  def resolve_unary(map, a, op) do
    {updated_map_a, value_a} = value_for_node(map, a)
    {updated_map_a, op.(value_a)}
  end

  def resolve_binary(map, a, b, op) do
    {updated_map_a, value_a} = value_for_node(map, a)
    {updated_map_b, value_b} = value_for_node(updated_map_a, b)

    {updated_map_b, op.(value_a, value_b)}
  end
end
