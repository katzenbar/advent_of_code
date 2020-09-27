defmodule ExAdvent.Y2015.Day16 do
  def solve_part1 do
    found_compounds = detected_attributes()

    input()
    |> Enum.map(&parse_sue/1)
    |> Enum.filter(&matching_sue?(&1, found_compounds))
    |> List.first()
    |> elem(0)
    |> IO.puts()
  end

  def solve_part2 do
    found_compounds = detected_attributes()

    input()
    |> Enum.map(&parse_sue/1)
    |> Enum.filter(&matching_sue_pt2?(&1, found_compounds))
    |> List.first()
    |> elem(0)
    |> IO.puts()
  end

  def detected_attributes do
    ~s"""
    children: 3
    cats: 7
    samoyeds: 2
    pomeranians: 3
    akitas: 0
    vizslas: 0
    goldfish: 5
    trees: 3
    cars: 2
    perfumes: 1
    """
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.reduce(%{}, fn [k, v], acc -> Map.put(acc, k, String.to_integer(v)) end)
  end

  def input do
    File.read!("inputs/y2015/day16")
    |> String.trim()
    |> String.split("\n")
  end

  def parse_sue(input_line) do
    result = Regex.named_captures(~r/^Sue (?<sue>\d+?): (?<attributes>.*)$/, input_line)

    attributes =
      result["attributes"]
      |> String.split(", ")
      |> Enum.map(&String.split(&1, ": "))
      |> Enum.map(fn [k, v] -> [k, String.to_integer(v)] end)

    {result["sue"], attributes}
  end

  def matching_sue?({_sue, attributes}, found_compounds) do
    Enum.all?(attributes, fn [key, value] -> Map.get(found_compounds, key) == value end)
  end

  def matching_sue_pt2?({_sue, attributes}, found_compounds) do
    Enum.all?(attributes, fn [key, value] -> attribute_matches?(key, value, found_compounds) end)
  end

  def attribute_matches?(key, value, found_compounds) when key == "cats" or key == "trees" do
    Map.get(found_compounds, key) < value
  end

  def attribute_matches?(key, value, found_compounds)
      when key == "goldfish" or key == "pomeranians" do
    Map.get(found_compounds, key) > value
  end

  def attribute_matches?(key, value, found_compounds) do
    Map.get(found_compounds, key) == value
  end
end
