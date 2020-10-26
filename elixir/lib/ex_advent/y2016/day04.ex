defmodule ExAdvent.Y2016.Day04 do
  def solve_part1 do
    input()
    |> parse_input()
    |> Enum.filter(&is_real_room?/1)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> Enum.filter(&is_real_room?/1)
    |> Enum.filter(fn {l, s, _c} -> decrypt_name(l, s) == "northpole object storage" end)
    |> Enum.map(&elem(&1, 1))
    |> List.first()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2016/day04")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_room/1)
  end

  def parse_room(room) do
    %{"l" => letters, "s" => sector, "c" => checksum} =
      Regex.named_captures(~r/(?<l>[a-z\-]+)-(?<s>\d+)\[(?<c>[a-z]+)\]/, room)

    {letters, String.to_integer(sector), checksum}
  end

  def is_real_room?({letters, _sector, checksum}) do
    checksum == calculate_checksum(letters)
  end

  def calculate_checksum(letters) do
    letters
    |> String.replace("-", "")
    |> String.split("", trim: true)
    |> Enum.group_by(& &1)
    |> Enum.to_list()
    |> Enum.map(fn {letter, list} -> {letter, Enum.count(list)} end)
    # flip count so both fields sort in the same direction
    |> Enum.sort_by(fn {letter, count} -> {-1 * count, letter} end)
    |> Enum.take(5)
    |> Enum.map(&elem(&1, 0))
    |> Enum.join()
  end

  def decrypt_name(letters, sector) do
    letters
    |> String.to_charlist()
    |> Enum.map(fn x ->
      case x do
        ?- -> ' '
        _ -> rem(x - ?a + sector, 26) + ?a
      end
    end)
    |> List.to_string()
  end
end
