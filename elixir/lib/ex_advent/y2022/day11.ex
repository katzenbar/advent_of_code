defmodule ExAdvent.Y2022.Day11 do
  def solve_part1 do
    input()
    |> parse_input()
    |> get_monkey_business(20)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> get_monkey_business_with_lcd(10_000)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day11")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&parse_monkey/1)
    |> Enum.reduce(%{}, fn monkey, monkey_map ->
      Map.put(monkey_map, elem(monkey, 0), Tuple.delete_at(monkey, 0))
    end)
  end

  def parse_monkey(input) do
    [monkey, items, operation, test, throw_true, throw_false] = String.split(input, "\n")

    monkey = parse_out_number(monkey)

    items =
      items
      |> String.trim()
      |> String.replace("Starting items: ", "")
      |> String.split(", ")
      |> Enum.map(&String.to_integer/1)

    operation = parse_operation(operation)
    test = parse_out_number(test)
    throw_true = parse_out_number(throw_true)
    throw_false = parse_out_number(throw_false)

    {monkey, items, operation, test, throw_true, throw_false, 0}
  end

  def parse_out_number(input), do: input |> String.replace(~r/[^\d]/, "") |> String.to_integer()

  def parse_operation(operation) do
    [a, op, b] =
      operation
      |> String.trim()
      |> String.replace("Operation: new = ", "")
      |> String.split(" ")

    op =
      case op do
        "*" -> :mul
        "+" -> :add
      end

    a =
      case a do
        "old" -> :old
        _ -> String.to_integer(a)
      end

    b =
      case b do
        "old" -> :old
        _ -> String.to_integer(b)
      end

    {a, op, b}
  end

  def get_monkey_business(monkeys, num_rounds) do
    simulate_rounds(monkeys, 3, 0, num_rounds)
    |> Map.values()
    |> Enum.map(&elem(&1, 5))
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(2)
    |> Enum.product()
  end

  def get_monkey_business_with_lcd(monkeys, num_rounds) do
    lcd =
      monkeys
      |> Map.values()
      |> Enum.map(&elem(&1, 2))
      |> Enum.product()

    simulate_rounds(monkeys, 1, lcd, num_rounds)
    |> Map.values()
    |> Enum.map(&elem(&1, 5))
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(2)
    |> Enum.product()
  end

  def simulate_rounds(monkeys, worry_divider, lcd, num_rounds) do
    1..num_rounds
    |> Enum.reduce(monkeys, fn _, monkeys -> simulate_round(monkeys, worry_divider, lcd) end)
  end

  def simulate_round(monkeys, worry_divider, lcd) do
    Map.keys(monkeys)
    |> Enum.reduce(monkeys, &simulate_turn(&1, &2, worry_divider, lcd))
  end

  def simulate_turn(monkey_id, monkeys, worry_divider, lcd) do
    monkey = Map.get(monkeys, monkey_id)
    items = elem(monkey, 0)
    num_inspections = elem(monkey, 5) + length(items)

    Enum.reduce(items, monkeys, &simulate_item(&1, monkey, &2, worry_divider, lcd))
    |> Map.put(monkey_id, put_elem(monkey, 0, []) |> put_elem(5, num_inspections))
  end

  def simulate_item(item, monkey, monkeys, worry_divider, lcd) do
    {_, operation, test, throw_true, throw_false, _} = monkey
    worry = calculate_new_worry(item, operation)
    worry = div(worry, worry_divider)
    worry = if lcd > 0, do: rem(worry, lcd), else: worry

    throw_to_id =
      cond do
        rem(worry, test) == 0 -> throw_true
        true -> throw_false
      end

    throw_to_monkey = Map.get(monkeys, throw_to_id)
    throw_to_items = elem(throw_to_monkey, 0)
    Map.put(monkeys, throw_to_id, put_elem(throw_to_monkey, 0, List.insert_at(throw_to_items, -1, worry)))
  end

  def calculate_new_worry(item, {a, :mul, b}), do: get_op_value(a, item) * get_op_value(b, item)
  def calculate_new_worry(item, {a, :add, b}), do: get_op_value(a, item) + get_op_value(b, item)

  def get_op_value(:old, item), do: item
  def get_op_value(val, _), do: val
end
