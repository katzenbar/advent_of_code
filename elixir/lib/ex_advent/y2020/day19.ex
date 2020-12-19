defmodule ExAdvent.Y2020.Day19 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_completely_matching_messages(0)
    |> Enum.count()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_completely_matching_messages_pt2()
    |> Enum.count()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day19")
  end

  def parse_input(input) do
    [rules, messages] =
      input
      |> String.trim()
      |> String.split("\n\n")

    {parse_rules(rules), parse_messages(messages)}
  end

  def parse_rules(rules) do
    rules
    |> String.split("\n")
    |> Enum.map(&parse_rule/1)
    |> Enum.reduce(%{}, fn {key, value}, acc -> Map.put(acc, key, value) end)
  end

  def parse_rule(rule) do
    [key, rule_seg] = String.split(rule, ": ")
    {String.to_integer(key), parse_rule_segment(rule_seg)}
  end

  def parse_rule_segment("\"" <> value) do
    [String.replace(value, "\"", "")]
  end

  def parse_rule_segment(rule_segment) do
    cond do
      String.contains?(rule_segment, "|") ->
        rule_segment
        |> String.split(" | ")
        |> Enum.flat_map(&parse_rule_segment/1)

      true ->
        rule =
          rule_segment
          |> String.split(" ")
          |> Enum.map(&String.to_integer/1)

        [rule]
    end
  end

  def parse_messages(messages) do
    String.split(messages, "\n")
  end

  def find_completely_matching_messages({rules, messages}, rule_key) do
    values =
      get_possible_values_for_rule(rules, rule_key)
      |> Map.get(rule_key)
      |> MapSet.new()

    messages
    |> Enum.filter(&MapSet.member?(values, &1))
  end

  def get_possible_values_for_rule(rules, key) do
    mappings = Map.get(rules, key)

    cond do
      is_binary(List.first(mappings)) ->
        rules

      true ->
        updated_rules =
          mappings
          |> List.flatten()
          |> Enum.reduce(rules, fn key, rules -> get_possible_values_for_rule(rules, key) end)

        possible_values =
          Enum.flat_map(mappings, fn mapping ->
            mapping
            |> Enum.map(fn key -> Map.get(updated_rules, key) end)
            |> combine_values()
          end)

        Map.put(updated_rules, key, possible_values)
    end
  end

  def combine_values([]), do: [""]

  def combine_values([values | rest]) do
    combine_values(rest)
    |> Enum.flat_map(fn y ->
      Enum.map(values, fn x -> x <> y end)
    end)
  end

  def find_completely_matching_messages_pt2({rules, messages}) do
    # Instead of replacing values as instructed, we're going to just hardcode how to interpret the recursion.
    # The modified rules were:
    #
    #   8: 42 | 42 8           (repeat possible values of 42 one or more times)
    #   11: 42 31 | 42 11 31   (repeat 42 then repeat 31 the same number of times, at least once)
    #
    # Note that in both the example and actual inputs, these are only used by our entry point, 0.
    #
    #   0: 8 11
    #
    # This translates to messages matching values that repeat 42 two or more times, and then repeat 31 one or more
    # times.
    updated_rules = get_possible_values_for_rule(rules, 0)

    possible42 = Map.get(updated_rules, 42)
    possible31 = Map.get(updated_rules, 31)

    # All of these possible values happen to be the same length (5 in the sample, 8 in the actual)
    rule_length = possible42 |> List.first() |> String.length()

    # The intersection of these sets is empty
    possible42 = MapSet.new(possible42)
    possible31 = MapSet.new(possible31)

    messages
    |> Stream.filter(fn m -> rem(String.length(m), rule_length) == 0 end)
    |> Stream.map(fn m ->
      String.split(m, Regex.compile!(".{#{rule_length}}"), trim: true, include_captures: true)
    end)
    |> Stream.map(fn message_chunks ->
      Enum.split_while(message_chunks, fn chunk -> MapSet.member?(possible42, chunk) end)
    end)
    |> Stream.filter(fn {_chunks42, chunks_remaining} ->
      Enum.all?(chunks_remaining, &MapSet.member?(possible31, &1))
    end)
    |> Stream.filter(fn {chunks42, chunks31} ->
      count42 = Enum.count(chunks42)
      count31 = Enum.count(chunks31)

      count31 > 0 && count42 > count31
    end)
    |> Stream.map(fn {a, b} ->
      Enum.concat(a, b) |> Enum.join("")
    end)
    |> Enum.to_list()
  end
end
