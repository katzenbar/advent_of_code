defmodule ExAdvent.Y2020.Day04 do
  def solve_part1 do
    input()
    |> parse_input()
    |> Enum.count(&passport_has_all_required_fields?/1)
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> Enum.count(&passport_valid?/1)
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2020/day04")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&parse_passport/1)
  end

  def parse_passport(passport_str) do
    passport_str
    |> String.split(~r/[ \n]/)
    |> Enum.map(&parse_entry/1)
  end

  def parse_entry(passport_entry_str) do
    passport_entry_str
    |> String.split(":")
    |> List.to_tuple()
  end

  def passport_has_all_required_fields?(passport) do
    passport_fields = MapSet.new(Enum.map(passport, &elem(&1, 0)))

    MapSet.subset?(
      MapSet.new(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]),
      passport_fields
    )
  end

  def passport_valid?(passport) do
    case passport_has_all_required_fields?(passport) do
      true ->
        Enum.all?(passport, &passport_field_valid?/1)

      false ->
        false
    end
  end

  # cid (Country ID) - ignored, missing or not.
  def passport_field_valid?({"cid", _}) do
    true
  end

  # byr (Birth Year) - four digits; at least 1920 and at most 2002.
  def passport_field_valid?({"byr", value}) do
    year_between?(value, 1920, 2002)
  end

  # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
  def passport_field_valid?({"iyr", value}) do
    year_between?(value, 2010, 2020)
  end

  # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
  def passport_field_valid?({"eyr", value}) do
    year_between?(value, 2020, 2030)
  end

  # hgt (Height) - a number followed by either cm or in:
  # - If cm, the number must be at least 150 and at most 193.
  # - If in, the number must be at least 59 and at most 76.
  def passport_field_valid?({"hgt", value}) do
    captures = Regex.named_captures(~r/^(?<n>\d+)(?<u>cm|in)$/, value)

    case captures do
      %{"n" => num, "u" => "in"} ->
        height = String.to_integer(num)
        59 <= height && height <= 76

      %{"n" => num, "u" => "cm"} ->
        height = String.to_integer(num)
        150 <= height && height <= 193

      _ ->
        false
    end
  end

  # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
  def passport_field_valid?({"hcl", value}) do
    String.match?(value, ~r/^#[0-9a-f]{6}$/)
  end

  # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
  def passport_field_valid?({"ecl", value}) do
    String.match?(value, ~r/^amb|blu|brn|gry|grn|hzl|oth$/)
  end

  # pid (Passport ID) - a nine-digit number, including leading zeroes.
  def passport_field_valid?({"pid", value}) do
    String.match?(value, ~r/^\d{9}$/)
  end

  def year_between?(value, min, max) do
    case String.match?(value, ~r/\d{4}/) do
      true ->
        year = String.to_integer(value)
        min <= year && year <= max

      false ->
        false
    end
  end
end
