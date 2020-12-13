defmodule ExAdvent.Y2020.Day13 do
  def solve_part1 do
    input()
    |> parse_input()
    |> find_next_bus_for_timestamp()
    |> part_1_bus_score()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> find_golden_minute()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day13")
  end

  def parse_input(input) do
    [timestamp, buses] =
      input
      |> String.trim()
      |> String.split("\n")

    buses =
      buses
      |> String.split(",")
      |> Enum.map(fn bus ->
        case bus do
          "x" -> nil
          _ -> String.to_integer(bus)
        end
      end)

    {String.to_integer(timestamp), buses}
  end

  def part_1_bus_score({bus, wait_time}) do
    bus * wait_time
  end

  def find_next_bus_for_timestamp({timestamp, buses}) do
    {bus, departs_at} =
      buses
      |> Enum.filter(& &1)
      |> Enum.map(fn bus ->
        {bus, ceil(timestamp / bus) * bus}
      end)
      |> Enum.min_by(fn {_, ts} -> ts end)

    {bus, departs_at - timestamp}
  end

  def find_golden_minute({_, buses}) do
    buses_with_offset =
      buses
      |> Enum.with_index()
      |> Enum.filter(fn {bus, _} -> bus end)

    {rem, max} = chinese_remainder(buses_with_offset)
    max - rem
  end

  # Takes a list of [{mod, remainder}]
  def chinese_remainder(pairs) do
    max =
      pairs
      |> Enum.map(&elem(&1, 0))
      |> Enum.reduce(&*/2)

    result =
      pairs
      |> Enum.map(fn {m, r} -> div(r * max * invmod(div(max, m), m), m) end)
      |> Enum.reduce(&+/2)

    {rem(result, max), max}
  end

  # Taken from https://rosettacode.org/wiki/Modular_inverse
  def invmod(e, et) do
    {g, x} = extended_gcd(e, et)
    if g != 1, do: raise("Something went very wrong")
    rem(x + et, et)
  end

  def extended_gcd(a, b) do
    {last_remainder, last_x} = extended_gcd(abs(a), abs(b), 1, 0, 0, 1)
    {last_remainder, last_x * if(a < 0, do: -1, else: 1)}
  end

  defp extended_gcd(last_remainder, 0, last_x, _, _, _), do: {last_remainder, last_x}

  defp extended_gcd(last_remainder, remainder, last_x, x, last_y, y) do
    quotient = div(last_remainder, remainder)
    remainder2 = rem(last_remainder, remainder)
    extended_gcd(remainder, remainder2, x, last_x - quotient * x, y, last_y - quotient * y)
  end
end
