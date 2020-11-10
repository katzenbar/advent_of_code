defmodule ExAdvent.Y2016.Day07 do
  def solve_part1 do
    input()
    |> parse_input()
    |> Enum.filter(&supports_tls?/1)
    |> Enum.count()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> Enum.filter(&supports_ssl?/1)
    |> Enum.count()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2016/day07")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
  end

  def supports_tls?(str) do
    Enum.any?(main_sequences(str), &has_abba?/1) &&
      !Enum.any?(hypernet_sequences(str), &has_abba?/1)
  end

  def main_sequences(str) do
    Regex.split(~r/\[(.+?)\]/, str)
  end

  def hypernet_sequences(str) do
    Regex.scan(~r/\[(.+?)\]/, str)
    |> Enum.map(fn [_full, capture] -> capture end)
  end

  def has_abba?(str) do
    Regex.match?(~r/(.)(?!\1)(.)\2\1/, str)
  end

  def supports_ssl?(str) do
    abas =
      str
      |> main_sequences()
      |> Enum.flat_map(&get_abas/1)

    str
    |> hypernet_sequences()
    |> Enum.any?(fn str -> has_babs?(str, abas) end)
  end

  def get_abas(str) do
    Regex.scan(~r/(.)(?!\1)(?=.\1)/, str, return: :index)
    |> Enum.map(fn [{idx, _}, _] -> {String.at(str, idx), String.at(str, idx + 1)} end)
  end

  def has_babs?(_str, []) do
    false
  end

  def has_babs?(str, abas) do
    Enum.any?(abas, fn {a, b} -> String.contains?(str, "#{b}#{a}#{b}") end)
  end
end
