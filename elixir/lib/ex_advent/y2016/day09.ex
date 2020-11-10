defmodule ExAdvent.Y2016.Day09 do
  def solve_part1 do
    input()
    |> parse_input()
    |> decompress_once()
    |> String.length()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> count_deep_decompressed_chars()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2016/day09")
  end

  def parse_input(input) do
    input
    |> String.trim()
  end

  def decompress_once(str) do
    case has_marker?(str) do
      true ->
        {start, repeats, rest} = decompress_next_marker(str)
        start <> repeats <> decompress_once(rest)

      false ->
        str
    end
  end

  def count_deep_decompressed_chars(str) do
    case has_marker?(str) do
      true ->
        %{"start" => start, "num_char" => num_char, "num_repeat" => num_repeat, "rest" => rest} =
          Regex.named_captures(
            ~r/(?<start>.*?)\((?<num_char>\d+)x(?<num_repeat>\d+)\)(?<rest>.*)/,
            str
          )

        {repeated, rest} = String.split_at(rest, String.to_integer(num_char))

        String.length(start) +
          String.to_integer(num_repeat) * count_deep_decompressed_chars(repeated) +
          count_deep_decompressed_chars(rest)

      false ->
        String.length(str)
    end
  end

  def has_marker?(str) do
    Regex.match?(~r/\(\d+x\d+\)/, str)
  end

  def decompress_next_marker(str) do
    %{"start" => start, "num_char" => num_char, "num_repeat" => num_repeat, "rest" => rest} =
      Regex.named_captures(
        ~r/(?<start>.*?)\((?<num_char>\d+)x(?<num_repeat>\d+)\)(?<rest>.*)/,
        str
      )

    {repeated, rest} = String.split_at(rest, String.to_integer(num_char))

    repeats =
      1..String.to_integer(num_repeat)
      |> Enum.map(fn _ -> repeated end)
      |> Enum.join("")

    {start, repeats, rest}
  end
end
