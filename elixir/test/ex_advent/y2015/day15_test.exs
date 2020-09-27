defmodule ExAdvent.Y2015.Day15Test do
  use ExUnit.Case

  import ExAdvent.Y2015.Day15

  # Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
  # Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3

  test "parse_line" do
    assert parse_line("Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8") ==
             {-1, -2, 6, 3, 8}
  end

  test "scores_for_distributed_ingredients" do
    distributed_ingredients = %{{-1, -2, 6, 3, 8} => 44, {2, 3, -2, -1, 3} => 56}

    assert scores_for_distributed_ingredients(distributed_ingredients) == {520, 62_842_880}
  end

  test "distribute_ingredients - 0" do
    ingredients = [
      {-1, -2, 6, 3, 8},
      {2, 3, -2, -1, 3}
    ]

    assert distribute_ingredients(ingredients, 0) |> Enum.to_list() == [
             %{{-1, -2, 6, 3, 8} => 0, {2, 3, -2, -1, 3} => 0}
           ]
  end

  test "distribute_ingredients - 1" do
    ingredients = [
      {-1, -2, 6, 3, 8},
      {2, 3, -2, -1, 3}
    ]

    assert distribute_ingredients(ingredients, 1) |> Enum.to_list() == [
             %{{-1, -2, 6, 3, 8} => 1, {2, 3, -2, -1, 3} => 0},
             %{{-1, -2, 6, 3, 8} => 0, {2, 3, -2, -1, 3} => 1}
           ]
  end

  test "distribute_ingredients - 2" do
    ingredients = [
      {-1, -2, 6, 3, 8},
      {2, 3, -2, -1, 3}
    ]

    assert distribute_ingredients(ingredients, 2) |> Enum.to_list() == [
             %{{-1, -2, 6, 3, 8} => 2, {2, 3, -2, -1, 3} => 0},
             %{{-1, -2, 6, 3, 8} => 1, {2, 3, -2, -1, 3} => 1},
             %{{-1, -2, 6, 3, 8} => 0, {2, 3, -2, -1, 3} => 2}
           ]
  end

  test "max_score_for_ingredients" do
    ingredients = [
      {-1, -2, 6, 3, 8},
      {2, 3, -2, -1, 3}
    ]

    assert max_score_for_ingredients(ingredients, 100) == 62_842_880
  end

  test "max_score_with_target_calories" do
    ingredients = [
      {-1, -2, 6, 3, 8},
      {2, 3, -2, -1, 3}
    ]

    assert max_score_with_target_calories(ingredients, 500, 100) == 57_600_000
  end
end
