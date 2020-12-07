defmodule ExAdvent.Y2020.Day07Test do
  use ExUnit.Case

  import ExAdvent.Y2020.Day07

  test "parse input - pt 1" do
    input = ~s"""
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
    """

    assert parse_input(input) == [
             {"light red", [{"bright white", 1}, {"muted yellow", 2}]},
             {"dark orange", [{"bright white", 3}, {"muted yellow", 4}]},
             {"bright white", [{"shiny gold", 1}]},
             {"muted yellow", [{"shiny gold", 2}, {"faded blue", 9}]},
             {"shiny gold", [{"dark olive", 1}, {"vibrant plum", 2}]},
             {"dark olive", [{"faded blue", 3}, {"dotted black", 4}]},
             {"vibrant plum", [{"faded blue", 5}, {"dotted black", 6}]},
             {"faded blue", []},
             {"dotted black", []}
           ]
  end

  test "parse input - pt 2" do
    input = ~s"""
    shiny gold bags contain 2 dark red bags.
    dark red bags contain 2 dark orange bags.
    dark orange bags contain 2 dark yellow bags.
    dark yellow bags contain 2 dark green bags.
    dark green bags contain 2 dark blue bags.
    dark blue bags contain 2 dark violet bags.
    dark violet bags contain no other bags.
    """

    assert parse_input(input) == [
             {"shiny gold", [{"dark red", 2}]},
             {"dark red", [{"dark orange", 2}]},
             {"dark orange", [{"dark yellow", 2}]},
             {"dark yellow", [{"dark green", 2}]},
             {"dark green", [{"dark blue", 2}]},
             {"dark blue", [{"dark violet", 2}]},
             {"dark violet", []}
           ]
  end

  test "build_container_map" do
    rules = [
      {"light red", [{"bright white", 1}, {"muted yellow", 2}]},
      {"dark orange", [{"bright white", 3}, {"muted yellow", 4}]},
      {"bright white", [{"shiny gold", 1}]},
      {"muted yellow", [{"shiny gold", 2}, {"faded blue", 9}]},
      {"shiny gold", [{"dark olive", 1}, {"vibrant plum", 2}]},
      {"dark olive", [{"faded blue", 3}, {"dotted black", 4}]},
      {"vibrant plum", [{"faded blue", 5}, {"dotted black", 6}]},
      {"faded blue", []},
      {"dotted black", []}
    ]

    assert build_container_map(rules) == %{
             "bright white" => [{"dark orange", 3}, {"light red", 1}],
             "dark olive" => [{"shiny gold", 1}],
             "dotted black" => [{"vibrant plum", 6}, {"dark olive", 4}],
             "faded blue" => [{"vibrant plum", 5}, {"dark olive", 3}, {"muted yellow", 9}],
             "muted yellow" => [{"dark orange", 4}, {"light red", 2}],
             "shiny gold" => [{"muted yellow", 2}, {"bright white", 1}],
             "vibrant plum" => [{"shiny gold", 2}]
           }
  end

  test "possible_outermost_containers" do
    container_map = %{
      "bright white" => [{"dark orange", 3}, {"light red", 1}],
      "dark olive" => [{"shiny gold", 1}],
      "dotted black" => [{"vibrant plum", 6}, {"dark olive", 4}],
      "faded blue" => [{"vibrant plum", 5}, {"dark olive", 3}, {"muted yellow", 9}],
      "muted yellow" => [{"dark orange", 4}, {"light red", 2}],
      "shiny gold" => [{"muted yellow", 2}, {"bright white", 1}],
      "vibrant plum" => [{"shiny gold", 2}]
    }

    assert possible_outermost_containers(container_map, "shiny gold") ==
             MapSet.new([
               "bright white",
               "muted yellow",
               "dark orange",
               "light red"
             ])
  end

  test "build_contents_map" do
    rules = [
      {"shiny gold", [{"dark red", 2}]},
      {"dark red", [{"dark orange", 2}]},
      {"dark orange", [{"dark yellow", 2}]},
      {"dark yellow", [{"dark green", 2}]},
      {"dark green", [{"dark blue", 2}]},
      {"dark blue", [{"dark violet", 2}]},
      {"dark violet", []}
    ]

    assert build_contents_map(rules) == %{
             "dark orange" => [{"dark yellow", 2}],
             "shiny gold" => [{"dark red", 2}],
             "dark blue" => [{"dark violet", 2}],
             "dark green" => [{"dark blue", 2}],
             "dark red" => [{"dark orange", 2}],
             "dark violet" => [],
             "dark yellow" => [{"dark green", 2}]
           }
  end

  test "count_bags" do
    contents_map = %{
      "dark orange" => [{"dark yellow", 2}],
      "shiny gold" => [{"dark red", 2}],
      "dark blue" => [{"dark violet", 2}],
      "dark green" => [{"dark blue", 2}],
      "dark red" => [{"dark orange", 2}],
      "dark violet" => [],
      "dark yellow" => [{"dark green", 2}]
    }

    assert count_bags(contents_map, "shiny gold") == 127
  end
end
