defmodule ExAdvent.Y2015.Day23 do
  def solve_part1 do
    input()
    |> parse_input()
    |> initial_machine()
    |> execute_program()
    |> Map.get("b")
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> initial_machine_pt2()
    |> execute_program()
    |> Map.get("b")
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day23")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      Regex.named_captures(
        ~r/(?<instruction>.+?) (?<register>a|b)?(, )?(?<offset>[+-]\d+)?/,
        line
      )
    end)
  end

  def initial_machine(instructions) do
    %{
      "a" => 0,
      "b" => 0,
      "execution_pointer" => 0,
      "instructions" => instructions
    }
  end

  def initial_machine_pt2(instructions) do
    %{
      "a" => 1,
      "b" => 0,
      "execution_pointer" => 0,
      "instructions" => instructions
    }
  end

  def execute_program(machine) do
    %{"execution_pointer" => execution_pointer, "instructions" => instructions} = machine

    cond do
      execution_pointer < 0 ->
        machine

      execution_pointer >= Enum.count(instructions) ->
        machine

      true ->
        Enum.at(instructions, execution_pointer)
        |> execute_instruction(machine)
        |> execute_program()
    end
  end

  def execute_instruction(%{"instruction" => "hlf", "register" => register}, machine) do
    machine
    |> Map.update!(register, fn x -> div(x, 2) end)
    |> Map.update!("execution_pointer", fn x -> x + 1 end)
  end

  def execute_instruction(%{"instruction" => "inc", "register" => register}, machine) do
    machine
    |> Map.update!(register, fn x -> x + 1 end)
    |> Map.update!("execution_pointer", fn x -> x + 1 end)
  end

  def execute_instruction(%{"instruction" => "tpl", "register" => register}, machine) do
    machine
    |> Map.update!(register, fn x -> 3 * x end)
    |> Map.update!("execution_pointer", fn x -> x + 1 end)
  end

  def execute_instruction(%{"instruction" => "jmp", "offset" => offset}, machine) do
    Map.update!(machine, "execution_pointer", fn x -> x + String.to_integer(offset) end)
  end

  def execute_instruction(
        %{"instruction" => "jie", "register" => register, "offset" => offset},
        machine
      ) do
    val = Map.get(machine, register)

    cond do
      rem(val, 2) == 0 ->
        Map.update!(machine, "execution_pointer", fn x -> x + String.to_integer(offset) end)

      true ->
        Map.update!(machine, "execution_pointer", fn x -> x + 1 end)
    end
  end

  def execute_instruction(
        %{"instruction" => "jio", "register" => register, "offset" => offset},
        machine
      ) do
    val = Map.get(machine, register)

    cond do
      val == 1 ->
        Map.update!(machine, "execution_pointer", fn x -> x + String.to_integer(offset) end)

      true ->
        Map.update!(machine, "execution_pointer", fn x -> x + 1 end)
    end
  end
end
