defmodule ExAdvent.Y2020.Day21 do
  def solve_part1 do
    input()
    |> parse_input()
    |> count_appearances_of_non_allergens()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> canonical_dangerous_ingredient_list()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day21")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    %{"a" => allergens, "i" => ingredients} =
      Regex.named_captures(~r/(?<i>.*) \(contains (?<a>.*)\)/, line)

    {
      MapSet.new(String.split(ingredients, " ")),
      String.split(allergens, ", ")
    }
  end

  def count_appearances_of_non_allergens(foods) do
    possible_allergens =
      foods
      |> find_possible_allergens()
      |> Map.values()
      |> Enum.reduce(&MapSet.union/2)

    foods
    |> Enum.map(fn {ingredients, _} ->
      ingredients
      |> MapSet.difference(possible_allergens)
      |> MapSet.size()
    end)
    |> Enum.sum()
  end

  def canonical_dangerous_ingredient_list(foods) do
    foods
    |> find_allergen_mappings()
    |> Map.to_list()
    |> Enum.sort_by(fn {a, _} -> a end)
    |> Enum.map(fn {_, i} -> i end)
    |> Enum.join(",")
  end

  def find_allergen_mappings(foods) do
    unmapped_allergens =
      foods
      |> find_possible_allergens()
      |> Map.to_list()

    find_allergen_mappings(unmapped_allergens, %{})
  end

  defp find_allergen_mappings([], mapped_allergens), do: mapped_allergens

  defp find_allergen_mappings(unmapped_allergens, mapped_allergens) do
    mapped_ingredients =
      mapped_allergens
      |> Map.values()
      |> MapSet.new()

    {newly_mapped, still_unmapped} =
      unmapped_allergens
      |> Enum.map(fn {allergen, possible_ingredients} ->
        {allergen, MapSet.difference(possible_ingredients, mapped_ingredients)}
      end)
      |> Enum.split_with(fn {_, i} -> MapSet.size(i) == 1 end)

    mapped_allergens =
      Enum.reduce(
        newly_mapped,
        mapped_allergens,
        fn {allergen, possible_ingredients}, mapped_allergens ->
          ingredient = possible_ingredients |> MapSet.to_list() |> List.first()
          Map.put(mapped_allergens, allergen, ingredient)
        end
      )

    find_allergen_mappings(still_unmapped, mapped_allergens)
  end

  def find_possible_allergens(foods) do
    Enum.reduce(foods, %{}, fn {ingredients, allergens}, allergen_map ->
      Enum.reduce(allergens, allergen_map, fn allergen, allergen_map ->
        cond do
          Map.has_key?(allergen_map, allergen) ->
            Map.update!(allergen_map, allergen, &MapSet.intersection(&1, ingredients))

          true ->
            Map.put(allergen_map, allergen, ingredients)
        end
      end)
    end)
  end
end
