defmodule ExAdvent.Y2020.Day25 do
  def solve_part1 do
    input()
    |> parse_input()
    |> get_encryption_key()
    |> IO.puts()
  end

  def solve_part2 do
    IO.puts("No puzzle, merry christmas!")
  end

  def input do
    File.read!("inputs/y2020/day25")
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def get_encryption_key([public_key_a, public_key_b]) do
    loop_number_a = get_loop_number(public_key_a)
    transform_subject_number(public_key_b, loop_number_a)
  end

  def get_loop_number(public_key) do
    get_loop_number(public_key, 0, 1)
  end

  defp get_loop_number(public_key, loop_number, value) do
    case value == public_key do
      true ->
        loop_number

      false ->
        value = rem(value * 7, 20_201_227)
        get_loop_number(public_key, loop_number + 1, value)
    end
  end

  def transform_subject_number(subject_number, times) do
    Enum.reduce(1..times, 1, fn _, value ->
      rem(value * subject_number, 20_201_227)
    end)
  end
end
