defmodule ExAdvent.Y2015.Day15 do
  def solve_part1 do
    input()
    |> Enum.map(&parse_line/1)
    |> max_score_for_ingredients(100)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> Enum.map(&parse_line/1)
    |> max_score_with_target_calories(500, 100)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day15")
    |> String.trim()
    |> String.split("\n")
  end

  def parse_line(input_line) do
    result =
      Regex.named_captures(
        ~r/^(.+?): capacity (?<capacity>.+?), durability (?<durability>.+?), flavor (?<flavor>.+?), texture (?<texture>.+?), calories (?<calories>.+?)$/,
        input_line
      )

    [
      result["capacity"],
      result["durability"],
      result["flavor"],
      result["texture"],
      result["calories"]
    ]
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def max_score_for_ingredients(ingredients, amount) do
    ingredients
    |> score_ingredients(amount)
    |> Enum.map(&elem(&1, 1))
    |> Enum.max()
  end

  def max_score_with_target_calories(ingredients, target_calories, amount) do
    ingredients
    |> score_ingredients(amount)
    |> Stream.filter(fn {calories, _} -> calories == target_calories end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.max()
  end

  def score_ingredients(ingredients, amount) do
    distribute_ingredients(ingredients, amount)
    |> Stream.map(&scores_for_distributed_ingredients/1)
  end

  def scores_for_distributed_ingredients(distributed_ingredients) do
    distributed_ingredients
    |> Map.to_list()
    |> Enum.map(&calculate_score_components/1)
    |> combine_scores()
  end

  def calculate_score_components({{capacity, durability, flavor, texture, calories}, amount}) do
    {amount * calories,
     [amount * capacity, amount * durability, amount * flavor, amount * texture]}
  end

  def combine_scores(scores) do
    total_calories = Enum.map(scores, &elem(&1, 0)) |> Enum.sum()

    total_score =
      Enum.map(scores, &elem(&1, 1))
      |> Enum.zip()
      |> Enum.map(fn tuple -> Enum.max([0, Enum.sum(Tuple.to_list(tuple))]) end)
      |> Enum.reduce(1, &(&1 * &2))

    {total_calories, total_score}
  end

  def distribute_ingredients(ingredients, total_amount) do
    build_combinations([], total_amount, Enum.count(ingredients))
    |> Stream.filter(fn counts -> Enum.sum(counts) == total_amount end)
    |> Stream.map(fn list ->
      Enum.zip(ingredients, list)
      |> Enum.reduce(%{}, fn {ingredient, count}, acc -> Map.put(acc, ingredient, count) end)
    end)
  end

  def build_combinations(suffix, total, 1) do
    Stream.map(0..total, fn i -> [i | suffix] end)
  end

  def build_combinations(suffix, total, count) do
    Stream.flat_map(0..total, fn i -> build_combinations([i | suffix], total, count - 1) end)
  end
end
