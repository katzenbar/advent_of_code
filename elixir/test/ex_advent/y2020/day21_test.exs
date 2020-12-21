defmodule ExAdvent.Y2020.Day21Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day21

  test "parse input" do
    assert example_input() == [
             {MapSet.new(["mxmxvkd", "kfcds", "sqjhc", "nhms"]), ["dairy", "fish"]},
             {MapSet.new(["trh", "fvjkl", "sbzzf", "mxmxvkd"]), ["dairy"]},
             {MapSet.new(["sqjhc", "fvjkl"]), ["soy"]},
             {MapSet.new(["sqjhc", "mxmxvkd", "sbzzf"]), ["fish"]}
           ]
  end

  test "find_possible_allergens" do
    assert find_possible_allergens(example_input()) == %{
             "dairy" => MapSet.new(["mxmxvkd"]),
             "fish" => MapSet.new(["mxmxvkd", "sqjhc"]),
             "soy" => MapSet.new(["fvjkl", "sqjhc"])
           }
  end

  test "count_appearances_of_non_allergens" do
    assert count_appearances_of_non_allergens(example_input()) == 5
  end

  test "find_allergen_mappings" do
    assert find_allergen_mappings(example_input()) == %{
             "dairy" => "mxmxvkd",
             "fish" => "sqjhc",
             "soy" => "fvjkl"
           }
  end

  test "canonical_dangerous_ingredient_list" do
    assert canonical_dangerous_ingredient_list(example_input()) == "mxmxvkd,sqjhc,fvjkl"
  end

  def example_input do
    input = ~s"""
    mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
    trh fvjkl sbzzf mxmxvkd (contains dairy)
    sqjhc fvjkl (contains soy)
    sqjhc mxmxvkd sbzzf (contains fish)
    """

    parse_input(input)
  end
end
