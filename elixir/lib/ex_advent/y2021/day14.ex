defmodule ExAdvent.Y2021.Day14 do
  def solve_part1 do
    input()
    |> parse_input()
    |> calculate_most_vs_least_common(10)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> calculate_most_vs_least_common(40)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2021/day14")
  end

  def parse_input(input) do
    [template, insertion_rules] =
      input
      |> String.trim()
      |> String.split("\n\n")

    template = String.to_charlist(template)
    insertion_rules = parse_insertion_rules(insertion_rules)

    {template, insertion_rules}
  end

  defp parse_insertion_rules(insertion_rules) do
    insertion_rules
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " -> "))
    |> Enum.reduce(%{}, fn [source, target], insertion_rules ->
      source = String.to_charlist(source)
      target = String.to_charlist(target) |> List.first()

      Map.put(insertion_rules, source, target)
    end)
  end

  def calculate_most_vs_least_common(input, num_steps) do
    counts = calculate_char_counts(input, num_steps)

    {count_min, count_max} = Enum.min_max(Map.values(counts))

    count_max - count_min
  end

  def calculate_char_counts({template, insertion_rules}, num_steps) do
    counts =
      template
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce({%{}, %{}}, fn char_pair, {prev_counts, pair_cache} ->
        {counts, pair_cache} = get_counts_for_pair(insertion_rules, char_pair, num_steps, pair_cache)

        counts = Map.merge(prev_counts, counts, fn _k, v1, v2 -> v1 + v2 end)

        {counts, pair_cache}
      end)
      |> elem(0)

    # We've double counted all the middle characters in the template string, remove those
    Enum.slice(template, 1..-2)
    |> Enum.reduce(counts, fn ch, counts ->
      Map.update!(counts, ch, &(&1 - 1))
    end)
  end

  def get_counts_for_pair(insertion_rules, char_pair, steps_remaining, pair_cache \\ %{})

  def get_counts_for_pair(_, char_pair, 0, pair_cache) do
    counts =
      Enum.reduce(char_pair, %{}, fn ch, counts ->
        Map.update(counts, ch, 1, &(&1 + 1))
      end)

    pair_cache = Map.put(pair_cache, {char_pair, 0}, counts)

    {counts, pair_cache}
  end

  def get_counts_for_pair(insertion_rules, char_pair, steps_remaining, pair_cache) do
    cond do
      Map.has_key?(pair_cache, {char_pair, steps_remaining}) ->
        {Map.get(pair_cache, {char_pair, steps_remaining}), pair_cache}

      true ->
        [first_ch | [second_ch | []]] = char_pair
        insert_ch = Map.get(insertion_rules, char_pair)

        {first_counts, pair_cache} =
          get_counts_for_pair(insertion_rules, [first_ch, insert_ch], steps_remaining - 1, pair_cache)

        {second_counts, pair_cache} =
          get_counts_for_pair(insertion_rules, [insert_ch, second_ch], steps_remaining - 1, pair_cache)

        counts =
          Map.merge(first_counts, second_counts, fn _k, v1, v2 -> v1 + v2 end)
          |> Map.update!(insert_ch, fn v -> v - 1 end)

        pair_cache = Map.put(pair_cache, {char_pair, steps_remaining}, counts)

        {counts, pair_cache}
    end
  end
end
