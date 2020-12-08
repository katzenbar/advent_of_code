defmodule ExAdvent.Y2020.Day08 do
  def solve_part1 do
    input()
    |> parse_input()
    |> execute_loop_once()
    |> Map.get(:accumulator)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> fix_program()
    |> Map.get(:accumulator)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day08")
  end

  def parse_input(input) do
    instructions =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&parse_instruction/1)

    %{
      execution_pointer: 0,
      accumulator: 0,
      instructions: instructions
    }
  end

  def parse_instruction("nop " <> val) do
    {:nop, String.to_integer(val)}
  end

  def parse_instruction("acc " <> val) do
    {:acc, String.to_integer(val)}
  end

  def parse_instruction("jmp " <> val) do
    {:jmp, String.to_integer(val)}
  end

  def fix_program(system) do
    %{instructions: instructions} = system
    last_instruction_idx = Enum.count(instructions) - 1

    Stream.map(0..last_instruction_idx, fn idx_to_fix ->
      case Enum.at(instructions, idx_to_fix) do
        {:jmp, val} ->
          fixed_instructions = List.replace_at(instructions, idx_to_fix, {:nop, val})
          Map.put(system, :instructions, fixed_instructions)

        {:nop, val} ->
          fixed_instructions = List.replace_at(instructions, idx_to_fix, {:jmp, val})
          Map.put(system, :instructions, fixed_instructions)

        _ ->
          nil
      end
    end)
    |> Stream.filter(& &1)
    |> Stream.map(&execute_loop_once/1)
    |> Stream.filter(fn %{execution_pointer: execution_pointer} ->
      execution_pointer == last_instruction_idx + 1
    end)
    |> Enum.at(0)
  end

  def execute_loop_once(system, visited_instructions \\ MapSet.new()) do
    %{execution_pointer: execution_pointer, instructions: instructions} = system

    cond do
      MapSet.member?(visited_instructions, execution_pointer) ->
        system

      execution_pointer == Enum.count(instructions) ->
        system

      true ->
        system = execute_next_instruction(system)
        visited_instructions = MapSet.put(visited_instructions, execution_pointer)
        execute_loop_once(system, visited_instructions)
    end
  end

  def execute_next_instruction(system) do
    %{
      execution_pointer: execution_pointer,
      accumulator: accumulator,
      instructions: instructions
    } = system

    instruction = Enum.at(instructions, execution_pointer)
    {next_ep, next_acc} = execute_instruction(instruction, execution_pointer, accumulator)

    %{
      execution_pointer: next_ep,
      accumulator: next_acc,
      instructions: instructions
    }
  end

  def execute_instruction({:nop, _}, ep, acc) do
    {ep + 1, acc}
  end

  def execute_instruction({:acc, value}, ep, acc) do
    {ep + 1, acc + value}
  end

  def execute_instruction({:jmp, value}, ep, acc) do
    {ep + value, acc}
  end
end
