defmodule ExAdvent.Y2021.Day24 do
  def solve_part1 do
    input()
    |> parse_input()
    |> execute_instructions()
    |> Enum.each(fn state -> IO.inspect(state, limit: :infinity, width: :infinity) end)
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day24")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(input_line) do
    %{"inst" => inst, "a1" => a1, "a2" => a2} =
      Regex.named_captures(~r/(?<inst>.*?) (?<a1>[wxyz]) ?(?<a2>[wxyz0-9\-]*)/, input_line)

    a2 =
      cond do
        a2 == "" -> nil
        String.match?(a2, ~r/[wxyz]/) -> a2
        true -> String.to_integer(a2)
      end

    {inst, a1, a2}
  end

  # def find_largest_valid_serial_number(monad_program) do
  #   Stream.iterate(99_999_999_999_999, &(&1 - 1))
  #   |> Stream.map(&Integer.to_string/1)
  #   |> Stream.filter(fn str -> !String.contains?(str, "0") end)
  #   |> Stream.map(fn str -> str |> IO.inspect() |> String.split("", trim: true) |> Enum.map(&String.to_integer/1) end)
  #   |> Stream.map(fn input -> {input, execute_instructions(monad_program, input)} end)
  #   |> Stream.filter(fn {_, %{"z" => verification_flag}} -> verification_flag == 0 end)
  #   |> Enum.at(0)
  # end

  def execute_instructions(instructions) do
    input = Enum.map(1..14, fn idx -> "a#{idx}" |> String.to_atom() end)
    initial_state = %{"w" => 0, "x" => 0, "y" => 0, "z" => 0, "input" => input, "conditionals" => []}

    Enum.reduce(instructions, [initial_state], fn instruction, states ->
      # IO.inspect(instruction)

      Enum.flat_map(states, fn state ->
        execute_instruction(instruction, state)
        # |> IO.inspect()
      end)
    end)
  end

  def execute_instruction(instruction, state)

  def execute_instruction({"inp", variable, _}, state) do
    [value | remaining_input] = Map.get(state, "input")

    state =
      state
      |> Map.put(variable, value)
      |> Map.put("input", remaining_input)

    [state]
  end

  def execute_instruction({"add", variable, value}, state) do
    variable_value = Map.get(state, variable)
    target_value = get_value(value, state)

    value =
      cond do
        is_integer(variable_value) && is_integer(target_value) ->
          variable_value + target_value

        variable_value == 0 ->
          target_value

        target_value == 0 ->
          variable_value

        is_integer(target_value) ->
          case variable_value do
            {:+, symbol, v} -> {:+, symbol, v + target_value}
            _ -> {:+, variable_value, target_value}
          end

        true ->
          {:+, variable_value, target_value}
      end

    [Map.put(state, variable, value)]
  end

  def execute_instruction({"mul", variable, value}, state) do
    variable_value = Map.get(state, variable)
    target_value = get_value(value, state)

    value =
      cond do
        is_integer(variable_value) && is_integer(target_value) -> variable_value * target_value
        variable_value == 0 -> 0
        target_value == 0 -> 0
        variable_value == 1 -> target_value
        target_value == 1 -> variable_value
        true -> {:*, variable_value, target_value}
      end

    [Map.put(state, variable, value)]
  end

  def execute_instruction({"div", variable, value}, state) do
    variable_value = Map.get(state, variable)
    target_value = get_value(value, state)

    value =
      cond do
        is_integer(variable_value) && is_integer(target_value) ->
          div(variable_value, target_value)

        target_value == 1 ->
          variable_value

        target_value > 9 && is_atom(variable_value) ->
          0

        true ->
          case variable_value do
            {:*, ^target_value, v} -> v
            {:+, {:*, ^target_value, v}, {:+, _, _}} -> v
            {:+, {:*, v, ^target_value}, {:+, _, _}} -> v
            _ -> {:/, variable_value, target_value}
          end
      end

    [Map.put(state, variable, value)]
  end

  def execute_instruction({"mod", variable, value}, state) do
    variable_value = Map.get(state, variable)
    target_value = get_value(value, state)

    value =
      cond do
        is_integer(variable_value) && is_integer(target_value) ->
          rem(variable_value, target_value)

        true ->
          case variable_value do
            {:+, {:*, ^target_value, _}, remainder} -> remainder
            {:+, {:*, _, ^target_value}, remainder} -> remainder
            {:+, symbol, addition} -> {:+, symbol, addition}
            _ -> {:%, variable_value, target_value}
          end
      end

    [Map.put(state, variable, value)]
  end

  def execute_instruction({"eql", variable, value}, state) do
    variable_value = Map.get(state, variable)
    target_value = get_value(value, state)

    cond do
      is_integer(variable_value) && is_integer(target_value) ->
        value = if variable_value == target_value, do: 1, else: 0

        [Map.put(state, variable, value)]

      is_integer(variable_value) && variable_value > 9 ->
        [Map.put(state, variable, 0)]

      is_integer(target_value) && target_value > 9 ->
        [Map.put(state, variable, 0)]

      true ->
        case variable_value do
          {:+, _, v} when abs(v) > 9 ->
            [Map.put(state, variable, 0)]

          _ ->
            true_branch =
              state |> Map.put(variable, 1) |> Map.update!("conditionals", &[{:eq, variable_value, target_value} | &1])

            false_branch =
              state |> Map.put(variable, 0) |> Map.update!("conditionals", &[{:neq, variable_value, target_value} | &1])

            [true_branch, false_branch]
        end
    end
  end

  defp get_value(value, _) when is_integer(value), do: value
  defp get_value(value, state), do: Map.get(state, value)
end
