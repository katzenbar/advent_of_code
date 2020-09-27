defmodule ExAdvent.Y2015.Day14 do
  def solve_part1 do
    input()
    |> Enum.map(&parse_line/1)
    |> Enum.map(&distance_after(&1, 2503))
    |> Enum.max()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> Enum.map(&parse_line/1)
    |> score_race(2503)
    |> Map.values()
    |> Enum.max()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2015/day14")
    |> String.trim()
    |> String.split("\n")
  end

  def parse_line(input) do
    result =
      Regex.named_captures(
        ~r/(?<name>.*?) can fly (?<speed>.*?) km\/s for (?<go_time>.*?) seconds, but then must rest for (?<rest_time>.*?) seconds./,
        input
      )

    {String.to_integer(result["speed"]), String.to_integer(result["go_time"]),
     String.to_integer(result["rest_time"])}
  end

  def distance_after({speed, go_time, rest_time}, seconds) do
    speed *
      (go_time * div(seconds, go_time + rest_time) + go_time -
         Enum.max([0, go_time - rem(seconds, go_time + rest_time)]))
  end

  def score_race(deers, seconds) do
    deer_scores = deers |> Enum.reduce(%{}, fn deer, map -> Map.put(map, deer, 0) end)

    1..seconds
    |> Enum.reduce(deer_scores, &score_second/2)
  end

  def score_second(second, deer_scores) do
    results =
      deer_scores
      |> Map.keys()
      |> Enum.map(fn deer -> {deer, distance_after(deer, second)} end)

    winning_distance = results |> Enum.map(&elem(&1, 1)) |> Enum.max()

    results
    |> Enum.filter(fn {_deer, score} -> score == winning_distance end)
    |> Enum.reduce(deer_scores, fn {deer, _score}, scores ->
      Map.get_and_update!(scores, deer, fn current_value ->
        {current_value, current_value + 1}
      end)
      |> elem(1)
    end)
  end
end
