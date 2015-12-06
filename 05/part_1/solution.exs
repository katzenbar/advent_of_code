defmodule Advent do
  def contains_three_vowels?(string) do
    number_of_vowels = String.replace(string, ~r/[^aeiou]/, "")
    |> String.length

    number_of_vowels >= 3
  end

  def contains_double_letters?(string) do
    String.match?(string, ~r/([a-z])\1/)
  end

  def contains_no_bad_strings?(string) do
    [
      String.contains?(string, "ab"),
      String.contains?(string, "cd"),
      String.contains?(string, "pq"),
      String.contains?(string, "xy"),
    ]
    |> Enum.all?(&(!&1))
  end

  def is_nice_string?(string) do
    [
      contains_three_vowels?(string),
      contains_double_letters?(string),
      contains_no_bad_strings?(string),
    ]
    |> Enum.all?
  end

  def input do
    { :ok, content } = File.read("input")
    String.split(content)
  end
end

IO.puts "--- Test Input ---"

IO.puts "ugknbfddgicrmopn"
IO.inspect Advent.is_nice_string?("ugknbfddgicrmopn")

IO.puts "---"

IO.puts "aaa"
IO.inspect Advent.is_nice_string?("aaa")

IO.puts "---"

IO.puts "jchzalrnumimnmhp"
IO.inspect Advent.is_nice_string?("jchzalrnumimnmhp")

IO.puts "---"

IO.puts "haegwjzuvuyypxyu"
IO.inspect Advent.is_nice_string?("haegwjzuvuyypxyu")

IO.puts "---"

IO.puts "dvszwmarrgswjxmb"
IO.inspect Advent.is_nice_string?("dvszwmarrgswjxmb")

IO.puts "--- Real Input ---"

Advent.input
|> Enum.map(&Advent.is_nice_string?/1)
|> Enum.filter(&(&1))
|> Enum.count
|> IO.inspect
