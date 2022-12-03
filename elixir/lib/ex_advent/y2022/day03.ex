defmodule ExAdvent.Y2022.Day03 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_items_to_rearrange()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_badge_priorities()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2022/day03")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
  end

  defp split_list_in_half(list) do
    len = length(list)
    Enum.split(list, floor(len / 2))
  end

  def find_items_to_rearrange(rucksacks) do
    rucksacks
    |> Enum.map(&split_list_in_half/1)
    |> Enum.map(&find_rucksack_common_item/1)
    |> Enum.map(&item_priority/1)
    |> Enum.sum()
  end

  def find_rucksack_common_item({comp1, comp2}) do
    MapSet.intersection(MapSet.new(comp1), MapSet.new(comp2))
    |> MapSet.to_list()
    |> Enum.at(0)
  end

  def find_badge_priorities(rucksacks) do
    rucksacks
    |> Enum.chunk_every(3)
    |> Enum.map(&find_badge_in_group/1)
    |> Enum.map(&item_priority/1)
    |> Enum.sum()
  end

  def find_badge_in_group(group) do
    group
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> MapSet.to_list()
    |> Enum.at(0)
  end

  def item_priority(ch) when ch <= ?Z, do: ch - ?A + 27
  def item_priority(ch), do: ch - ?a + 1
end
