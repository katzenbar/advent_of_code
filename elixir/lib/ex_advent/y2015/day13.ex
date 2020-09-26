defmodule ExAdvent.Y2015.Day13 do
  def solve_part1 do
    input()
    |> get_problem_description_pt1()
    |> score_seating_arrangements()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> get_problem_description_pt2()
    |> score_seating_arrangements()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day13")
    |> String.trim()
    |> String.split("\n")
  end

  def get_problem_description_pt1(input) do
    conditions = Enum.reduce(input, %{}, &parse_line/2)
    names = conditions |> Map.keys() |> List.flatten() |> MapSet.new()

    {names, conditions}
  end

  def get_problem_description_pt2(input) do
    conditions = Enum.reduce(input, %{}, &parse_line/2)
    names = conditions |> Map.keys() |> List.flatten() |> MapSet.new() |> MapSet.put("Me")

    {names, conditions}
  end

  def score_seating_arrangements({names, conditions}) do
    names
    |> build_seating_arrangements()
    |> Enum.map(&score_seating_arrangement(&1, conditions))
    |> Enum.max()
  end

  def score_seating_arrangement(arrangement, conditions) do
    arrangement
    |> Enum.flat_map(fn [a, b] -> [[a, b], [b, a]] end)
    |> Enum.map(&Map.get(conditions, &1, 0))
    |> Enum.sum()
  end

  def parse_line(input, conditions) do
    # Alice would gain 54 happiness units by sitting next to Bob.
    result =
      Regex.named_captures(
        ~r/(?<a>.*?) would (?<dir>gain|lose) (?<amt>\d+?) happiness units by sitting next to (?<b>.*?)\./,
        input
      )

    amount =
      case result["dir"] do
        "gain" -> String.to_integer(result["amt"])
        "lose" -> -1 * String.to_integer(result["amt"])
      end

    Map.put(conditions, [result["a"], result["b"]], amount)
  end

  def build_seating_arrangements(set) do
    set
    |> build_combinations()
    |> Enum.map(&Enum.chunk_every(&1, 2, 1, &1))
    |> Enum.map(&MapSet.new/1)
    |> Enum.uniq()
  end

  def build_combinations(set) do
    if MapSet.size(set) == 1 do
      [MapSet.to_list(set)]
    else
      set
      |> Enum.flat_map(fn x ->
        MapSet.delete(set, x)
        |> build_combinations()
        |> Enum.map(fn list -> [x | list] end)
      end)
    end
  end
end
