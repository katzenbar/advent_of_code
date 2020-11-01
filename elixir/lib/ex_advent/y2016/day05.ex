defmodule ExAdvent.Y2016.Day05 do
  def solve_part1 do
    input()
    |> parse_input()
    |> password_for_door_pt1()
    |> IO.puts()
  end

  def solve_part2 do
    input()
    |> parse_input()
    |> password_for_door_pt2()
    |> IO.puts()
  end

  def input do
    File.read!("inputs/y2016/day05")
  end

  @spec parse_input(binary) :: binary
  def parse_input(input) do
    input
    |> String.trim()
  end

  def password_for_door_pt1(door) do
    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(&hash("#{door}#{&1}"))
    |> Stream.map(&password_character/1)
    |> Stream.filter(& &1)
    |> Enum.take(8)
    |> Enum.join()
  end

  def password_for_door_pt2(door) do
    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(&hash("#{door}#{&1}"))
    |> Stream.scan(["_", "_", "_", "_", "_", "_", "_", "_"], &update_password/2)
    |> Stream.filter(fn x -> !Enum.any?(x, &(&1 == "_")) end)
    |> Enum.take(1)
    |> Enum.join()
  end

  def hash(str) do
    :crypto.hash(:md5, str) |> Base.encode16() |> String.downcase()
  end

  def password_character("00000" <> <<ch::bytes-size(1)>> <> _) do
    ch
  end

  def password_character(_) do
    nil
  end

  def update_password("00000" <> <<pos::bytes-size(1)>> <> <<ch::bytes-size(1)>> <> _, password) do
    position = String.to_integer(pos, 16)

    if position < 8 && Enum.at(password, position) == "_" do
      List.replace_at(password, position, ch)
    else
      password
    end
  end

  def update_password(_, password) do
    password
  end
end
