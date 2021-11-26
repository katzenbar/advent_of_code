defmodule ExAdvent.Y2018.Day03 do
  def solve_part1 do
    input()
    |> parse_input()
    |> number_of_cells_with_multiple_claims()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_non_overlapping_claim()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2018/day03")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(input_line) do
    result = Regex.named_captures(~r/#(?<id>\d+) @ (?<l>\d+),(?<t>\d+): (?<w>\d+)x(?<h>\d+)/, input_line)
    id = String.to_integer(result["id"])
    left = String.to_integer(result["l"])
    top = String.to_integer(result["t"])
    width = String.to_integer(result["w"])
    height = String.to_integer(result["h"])

    {id, left, top, width, height}
  end

  def mark_claims_on_map(claims) do
    claims
    |> Enum.reduce(%{}, &add_claim_to_map/2)
  end

  def add_claim_to_map({id, left, top, width, height}, claim_map) do
    Enum.reduce(left..(left + width - 1), claim_map, fn x, claim_map ->
      Enum.reduce(top..(top + height - 1), claim_map, fn y, claim_map ->
        key = "#{x},#{y}"
        Map.update(claim_map, key, MapSet.new([id]), &MapSet.put(&1, id))
      end)
    end)
  end

  def number_of_cells_with_multiple_claims(claims) do
    claims
    |> mark_claims_on_map()
    |> Map.values()
    |> Enum.count(&(MapSet.size(&1) > 1))
  end

  def find_non_overlapping_claim(claims) do
    claim_ids = MapSet.new(Enum.map(claims, &elem(&1, 0)))

    claims
    |> mark_claims_on_map()
    |> Map.values()
    |> Enum.reduce(claim_ids, fn claims_for_cell, possible_claim_ids ->
      case MapSet.size(claims_for_cell) > 1 do
        true ->
          MapSet.difference(possible_claim_ids, claims_for_cell)

        _ ->
          possible_claim_ids
      end
    end)
    |> MapSet.to_list()
    |> List.first()
  end
end
