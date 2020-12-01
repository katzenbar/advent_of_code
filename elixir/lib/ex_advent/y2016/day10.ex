defmodule ExAdvent.Y2016.Day10 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_target_comparison(["17", "61"])
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2016/day10")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(%{}, &parse_line/2)
  end

  def parse_line("value " <> str, state) do
    %{"bot" => bot, "value" => value} =
      Regex.named_captures(~r/(?<value>\d+) goes to bot (?<bot>\d+)/, str)

    Map.update(state, "bot#{bot}", [{:value, value}], fn inputs ->
      [{:value, value} | inputs]
    end)
  end

  def parse_line(str, state) do
    %{
      "bot" => bot,
      "low_type" => low_type,
      "low_num" => low_num,
      "high_type" => high_type,
      "high_num" => high_num
    } =
      Regex.named_captures(
        ~r/bot (?<bot>\d+) gives low to (?<low_type>.*) (?<low_num>\d+) and high to (?<high_type>.*) (?<high_num>\d+)/,
        str
      )

    state
    |> Map.update("#{low_type}#{low_num}", [{:bot_low, bot}], fn inputs ->
      [{:bot_low, bot} | inputs]
    end)
    |> Map.update("#{high_type}#{high_num}", [{:bot_high, bot}], fn inputs ->
      [{:bot_high, bot} | inputs]
    end)
  end

  def find_target_comparison(state, target) do
    Enum.reduce_while(Map.keys(state), state, fn key, state ->
      new_inputs = resolve_values(key, state)

      values =
        new_inputs
        |> Enum.map(&elem(&1, 1))
        |> Enum.sort_by(&String.to_integer/1)

      case values == target do
        true ->
          {:halt, key}

        _ ->
          {:cont, Map.put(state, key, new_inputs)}
      end
    end)
  end

  def resolve_values(key, state) do
    Map.get(state, key)
    |> Enum.map(fn input -> resolve_value(input, state) end)
  end

  def resolve_value({:value, value}, _) do
    {:value, value}
  end

  def resolve_value({:bot_low, bot_num}, state) do
    resolve_values("bot#{bot_num}", state)
    |> Enum.sort_by(fn {:value, value} -> String.to_integer(value) end)
    |> Enum.at(0)
  end

  def resolve_value({:bot_high, bot_num}, state) do
    resolve_values("bot#{bot_num}", state)
    |> Enum.sort_by(fn {:value, value} -> String.to_integer(value) end)
    |> Enum.reverse()
    |> Enum.at(0)
  end
end
